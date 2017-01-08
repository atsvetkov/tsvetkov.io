+++
Categories = []
Description = ""
Tags = []
date = "2017-01-08T18:11:53+01:00"
title = "coffee and links 4"
displaytitle = "Coffee and Links #4"

+++

Happy New Year everyone and thank you for reading this blog!

I decided to slightly modify the format of this series, so that the posts have only 3-5 links, but carefully selected and more focused ones. [Information overload](https://en.wikipedia.org/wiki/Information_overload) isn't a joke and trying to learn everything is often counterproductive (ask me how I know it), while picking your battles and practicing [deep reading](https://en.wikipedia.org/wiki/Slow_reading) helps internalize things you read.

{{< figure src="/images/coffee-and-links-4.jpg" title="" >}}

### Making the fastest site in the world

David Gilbertson wrote [a fascinating and hilarious post](https://hackernoon.com/10-things-i-learned-making-the-fastest-site-in-the-world-18a0e1cdf4a7#.3w8bfx9sf) about frontend optimization techniques, which you may or may not know. It's super funny to read, but also very enlightening and touching on a lot of very modern concepts, like [Preact](https://preactjs.com/), [service workers](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers), [prefetch and preload](https://www.keycdn.com/blog/resource-hints/) resource hints, using [Lighthouse](https://github.com/GoogleChrome/lighthouse) to measure performance metrics, and more. Highly recommended for anyone interested in [progressive web apps](https://developers.google.com/web/progressive-web-apps/) and web performance in general.

### Frameworks without the framework: why didn't we think of this sooner?

These days JavaScript frameworks have become almost a standard way of developing frontend apps. We throw in multiple scripts, loaded in memory and controlling the application workflow. Basically it's a *runtime* executed in the browser. While this is convenient, this also means a significant overhead. Looking at the two most popular frameworks at the moment, a minified React script is 139Kb and Angular 2 is 566Kb - wow, that's a lot for *just a framework*. Arguably there are very few web applications using all functionality from those libraries, so it seems that quite often we could get away with much less extra weight. But Rich Harris goes even further: *[do we need a runtime framework at all?](https://svelte.technology/blog/frameworks-without-the-framework/)* His answer to that is [Svelte](https://svelte.technology/), a very new and perhaps still experimental project, which implements a very simple idea: let's move the "framework" part from runtime to compile time. Svelte is essentially a build tool, allowing you to organize your application code into web components, which can then be *compiled* into the plain HTML and JavaScript files, without any framework. It also supports templates, scoped styles and server-side rendering - everything today's code hipsters want!

Let's look at a quick example. Imagine we have a *component* defined as an HTML file `HelloWorld.html` with the following content:
```
<h1>Hello {{name}}</h1>
```

Then we run a compiler against this file like this:
```
svelte compile --format iife HelloWorld.html > HelloWorld.js
```

Which results in a new `HelloWorld.js` file with quite some code in it:
```
var HelloWorld = (function () { 'use strict';

function renderMainFragment ( root, component ) {
	var h1 = createElement( 'h1' );
	
	appendNode( createText( "Hello " ), h1 );
	var text1 = createText( root.name );
	appendNode( text1, h1 );

	return {
		mount: function ( target, anchor ) {
			insertNode( h1, target, anchor );
		},
		
		update: function ( changed, root ) {
			text1.data = root.name;
		},
		
		teardown: function ( detach ) {
			if ( detach ) {
				detachNode( h1 );
			}
		}
	};
}

// more code
```

And this is where Svelte ends. You now have a web component, which can be referenced in a `<script>` tag and then mounted/removed by other components. You could categorize Svelte as just a smart code generator, but this doesn't change the facts: it solves the problem of managing a complex application code base, but without a runtime library overhead. To me this looks like a very powerful and promising concept, so I will definitely be following this project in 2017.

### ReSharper Interactive Tutorials

I have been using ReSharper for years and some refactorings are just a natural part of my workflow now. When I need to rename something, I press `Ctrl-R-R` before I even think about it. When I need a new file next to the currently open one, I would start writing the code right here and then `Alt-Enter`, `Move to <filename>.cs`. Still I probably only use between 5% and 10% of all functionality available. JetBrains developers recognize this problem, so they came up with a cool solution: instead of reading release notes or watching videos somewhere else, why not just go through [an interactive tutorial]((https://blog.jetbrains.com/dotnet/2016/12/22/resharper-interactive-tutorials/) without even leaving Visual Studio! These tutorials are now available as a [ReSharper extension](https://resharper-plugins.jetbrains.com/packages/JetBrains.ReSharperTutorials/) (make sure you already have the latest ReSharper 2016.3 installed). After that there will be a new "Tutorials" item in ReSharper menu, which will allow you to start one of two currently available tutorials (essentials and new features in version 2016.3). This will open a training solution and will guide you through several step-based exercises:

{{< figure src="/images/resharper_interactive_tutorials.png" title="" >}}

If you want to better know your favourite productivity plugin, go ahead and follow the tutorials!

### ASP.NET WebHooks

Many SaaS platforms these days use the concept of [web hooks](https://en.wikipedia.org/wiki/Webhook), providing a secure and managed way of integrating with your own application via HTTP. [GitHub](https://developer.github.com/webhooks/), [Slack](https://api.slack.com/incoming-webhooks), [Stripe](https://stripe.com/docs/webhooks) - all of them have some kind of web hook integration. From architectural perspective, this is nothing new: a web hook is an implementation of pub/sub pattern using HTTP-based API. So every ASP.NET Web API application can potentially expose some kind of custom controller for managing subscribers and other controllers to handle incoming requests/events. But the concept is obviously so popular, that Microsoft decided it deserves a built-in implementation.

Meet [ASP.NET WebHooks](https://blogs.msdn.microsoft.com/webdev/2016/12/14/introducing-microsoft-asp-net-webhooks-preview-2/), *"a simple pub/sub model for wiring together Web APIs and services with your code."* There are several related NuGet packages, which support both easily subscribing to a number of already existing web hook APIs out there (like the ones mentioned above) and also defining your own events which consumers can subscribe to. For example, this can very useful to quickly integrate several enterprise web applications in a loosely coupled way (pub/sub model exists for exactly this purpose), or connect an internal billing dashboard to Stripe, or allow some application behaviour to be triggered by a Slack command... the possibilities seem endless.

{{< figure src="/images/aspnet_webhooks_nuget_packages.png" title="" >}}

I'm thinking about applying this for a small RSS listener app, which will send a Slack message whenever there is a new post in this blog. Surely this can be done in many other ways, but still sounds like a good exercise.