+++
Categories = []
Description = ""
Tags = []
date = "2017-09-10T13:15:15+02:00"
title = "Feature toggles in .NET: tips and tricks"
+++

[Feature toggles](https://martinfowler.com/articles/feature-toggles.html) is a well-known pattern (or, rather, a set of patterns) for controlling how new functionality is delivered to the users. In a way, feature toggles are just glorified conditionals, but with an easy way to switch between "on" and "off".

### Types of feature toggles

According to Martin Fowler (see the link above), there are several types of feature toggles:

* **Release toggles** allow to ship the code with an incomplete feature which is just carefully isolated and turned off. This can be helpful when developing a certain user story spans muptiple sprints, but the team want to avoid long-living branches. There are certainly solid workflows which heavily rely on branching (like [git-flow](http://nvie.com/posts/a-successful-git-branching-model/) or [github flow](https://guides.github.com/introduction/flow/)), however, more and more organizations (including Google and Facebook, from what I read) are adopting the so-called [*trunk-based development*](https://trunkbaseddevelopment.com/), which uses Continuous Integration to ensure that the `master`/`main`/`trunk` branch is always of high quality and shippable.
* **Experiment toggles** are for things like [A/B Testing](https://en.wikipedia.org/wiki/A/B_testing), allowing to enable certain new functionality only to a subset of users. Unlike release features that are transient, experiment toggles can live in the code for a while, until it becomes clear whether the new feature proves to be successful.
* **Ops toggles** are usually short-lived and are only supposed to help with potential operational issues after deploying a new release (like, disabling a certain new part of the application at runtime if it causes performance degradation).
* **Permissioning toggles** are long-lived and allow to enable/disable features that are already stable, but are only intended for users of a certain pricing level (e.g. basic vs premium users).

From application architecture perspective, the important difference between these types is when and how they can be toggled. Release and Experiment toggles are likely to be set at deployment time, so from a running application perspective they are *static* settings. For instance, in a multi-tenant environment they would be defined as tenant settings and then injected into the application configuration somehow (e.g. `web.config` or environment variables). However, Ops and Permissioning toggles are *dynamic* and need to be configurable at runtime, so you might want to store them in a database of some sort.

Since the concept itself is quite simple, implementing feature toggles is also not too complicated. In .NET world, you could simply define the static ones as flags in a config file, whereas the dynamic ones would go to a database and probably be exposed to some administrative UI. But, of course, there are plenty of existing open-source libraries to help with this pattern.

### Feature toggle libraries for .NET

There's a lot to choose from: [NFeature](https://github.com/benaston/NFeature), [FeatureSwitcher](https://github.com/mexx/FeatureSwitcher), [nToggle](https://github.com/SteveMoyer/nToggle), [Toggler](https://github.com/manojlds/Toggler)... but most of them look abandoned. The one that is actively maintained (and is my favourite) is [FeatureToggle](https://github.com/jason-roberts/FeatureToggle) by [Jason Roberts](http://dontcodetired.com), a prolific open-source contributor, Microsoft MVP, and Pluralsight course author. His library is designed for simplicity and extensibility, providing several built-in convenient implementations and allowing to create your own.

The simplest feature toggle could look like this:
```
public class MyAwesomeFeature : SimpleFeatureToggle
{
}
```

The built-in `SimpleFeatureToggle` class will use .NET's `ConfigurationManager` to read the value of the toggle and it will be reading from `app.config` or `web.config` files. The setting names are convention-based, so this is how the feature toggle vallue would be set:
```
<configuration>
    <appSettings>
        <add key="FeatureToggle.MyAwesomeFeature" value="True" />
    </appSettings>
</configuration>
```

That is, if you're using it in the full .NET Framework application. Luckily, *FeatureToggle* supports .NET Core apps as well ([as of today, not finished yet, but RC3 looks stable](https://github.com/jason-roberts/FeatureToggle/issues/121#issuecomment-326871878)), so in this case it will search for the value in `appSettings.json` file. The convention is slightly different then, allowing to list multiple items under the same "FeatureToggle" node:
```
{
  "FeatureToggle": {
    "MyAwesomeFeature": "true"
  }
}
```

When it comes to checking the toggle value in the application code, it is just about creating an instance of the feature toggle class and using `FeatureEnabled` property:
```
var myAwesomeFeature = new MyAwesomeFeature();
if (myAwesomeFeature.FeatureEnabled)
{
    // it's on, do something
}
else
{
    // it's off, do something else
}
```

Some other handy built-in classes are `AlwaysOnFeatureToggle`, `EnabledOnOrAfterDateFeatureToggle`, `SqlFeatureToggle`, `EnabledOnDaysOfWeekFeatureToggle`, and even... `RandomFeatureToggle`! Not exactly sure why anyone would want the last one though.

### Helper classes

I really like this library (thanks, Jason!), but I don't really enjoy newing up the instances all the time just to check the values. Especially if the application is going to check them often, that seems like a lot of allocations. Furthermore, with the syntax like in the example above, unit testing will be very hard. How can we overcome this?

There are several ways and I won't pretend I know *the best* one. If the application uses some IoC container, the cleanest option, perhaps, would be to register all feature toggles and then constructor-inject them wherever they need to be checked. This, however, would require introducing a separate interface for each toggle, since you need to inject the right one. That sounds to me like losing all the original simplicity of this specific library. So, what we ended up doing in my current project is introducing a static class as a single entry point for toggles, defining the toggles themselves as *private nested classes*, and exposing them as properties:
```
public static class Features
{
    public static IFeatureToggle MyAwesome { get; set; } = new DefaultToDisabledOnErrorDecorator(new MyAwesomeFeature());

    private class MyAwesomeFeature : SimpleFeatureToggle
    { }
}
```

Note the use of `DefaultToDisabledOnErrorDecorator` here: by design, `SimpleFeatureToggle` will throw if a corresponding setting is not defined in the configuration/settings file. This definitely makes it clean and very explicit, however, in some cases, when the deployment story is complicated and not polished yet, we found it safer to use this decorator and default to `false`. So, no configuration setting will mean feature toggle is off in this case.

The private nested class means that this type cannot be used outside, ensuring that this is the only way to work with toggles. Now the toggle-checking code looks more readable, in my opinion:
```
if (Features.MyAwesome.FeatureEnabled)
{

}
```

Probably, this can be improved even further by only exposing the boolean property itself or wrapping these properties into `Lazy<T>` (will not create an instance of a toggle in memory until actuall used), that's just how we use it right now.

### Unit testing

Now, imagine we are writing a unit test for the class which has a feature toggle checked somewhere in the middle of some method. How do we mock it? If it was injected as an interface, it's no different from any other dependency: with a library like [Moq](https://github.com/moq/moq4), it is trivially easy to create an object that behaves like our feature toggle interface and returns whatever we told it to return:
```
public class MyAwesomeFeature : SimpleFeatureToggle, IMyAwesomeFeature
{
}

// somewhere in the unit test code
var mock = new Mock<IMyAwesomeFeature>();
mock.Setup(s => s.FeatureEnabled).Returns(true); // let's say we are testing the scenario when feature toggle is on
```

However, as much as proper mocks seem to be the cleanest way, there are simpler and more pragmatic ways too. This is why in our `Features` static class the properties have setters too! If we know that the target method is going to check the static feature toggle property, we can just set it to what we want as part of the test setup:
```
// somewhere in the unit test code
Features.MyAwesome = new AlwaysOnFeatureToggle();

// the rest of the test
```

Roy Osherove mentions this and some other pragmatic ways to deal with dependencies in his great book [The Art of Unit Testing](https://www.manning.com/books/the-art-of-unit-testing). As long as you know what you are doing and what you want to test, this approach is not less reliable than using mocks, but requires much less ceremony.

Finally, in situations when it is possible to completely abstract away the toggleable behaviour, the feature toggle checking code might be moved to IoC container setup, so that it registers different *implementations* of a certain interface depending on the toggle. That's probably not always possible and might require a refactoring, but in my opinion is certainly better than, for example, checking the feature toggle in a web API controller (ideally, there should be no significant business logic there at all).

### Conclusion

Feature toggles can be of great help in facilitating trunk-based development, which in turn should push developers towards doing the real Continuous Integration instead of practising [CI theatre](https://www.gocd.org/2017/05/16/its-not-CI-its-CI-theatre.html). [FeatureToggle](https://github.com/jason-roberts/FeatureToggle) is a very convenient library, although you might want to add some helper classes to improve the readability or performance. As a final note, to have better control and overview of feature toggles it might be interesting to look into one of the commercial SaaS solutions, like [LaunchDarkly](https://launchdarkly.com/).