+++
Categories = []
Description = ""
Tags = []
date = "2017-01-28T11:54:46+01:00"
title = "NDC London: talks"

+++

Last three days of NDC London presented a constant paradox of choice, since every hour 7-8 speakers would have parallel sessions in different rooms. How the hell am I supposed to pick only one, if all of them are great? How on earth can you choose between Jon Skeet and Mark Seeman? My way of solving this problem was to spend an hour every evening going through the list of the next day's speakers and googling their talks from the past. Sometimes this helped me to pick a brilliant talk from someone I had not known yet, sometimes this meant I would go to the Bill Wagner's talk and... well, more on that later.

Being an old-school geek, I still prefer to make notes on paper, so I have pretty good coverage of what I learned during these talks. Hopefully all the recorded sessions will be available on the web soon (that's the part I really like about NDC), but before this happens, here's a list of my observations and learnings from the talks I personally attended.

### Day 1

* In the keynote Richard Campbell was talking about the [Humanitarian Toolbox](http://www.htbox.org/), an open-source project for helping non-commercial organizations like Red Cross, and invited everyone to join. I'm really considering that, since there is a noble purpose and pretty nice technology stack too.

* Ian Cooper told us about [The Twelve-Factor Apps](https://12factor.net/), but on a really high level, so I didn't learn anything practical.

* Async/await in C# is still not well-understood by many developers, so [Filip Ekberg](http://www.filipekberg.se/) talked about the actual compiler logic behind this pattern and listed some gotchas. For example, you should never block on async code ([here is why](http://blog.stephencleary.com/2012/07/dont-block-on-async-code.html)) and it's better to avoid too many nested async method calls, because a compiler will create and instantiate a genereated state-machine class for each one, so there is some overhead.

* Dominick Baier and Brock Allen explained the differences between the recently released IdentityServer4 and widely-used IdensityServer3. It targets .NET Core, which means they don't have their own built-in DI and can rely on ASP.NET Core dependency resolution instead. *Scopes* were renamed to *ApiResources* and *IdentityResources*, since the concept of scopes wasn't obvious to people and usually would be explained like "think of them as *resources* to protect access to". Login UI is not included anymore, but there is a [quickstart project](https://github.com/IdentityServer/IdentityServer4.Quickstart.UI) to use as an example when building your own. Also, there is now a built-in temporary generated certificate, which makes the development-time configuration very easy.

* Scott Allen shared some of his experience with modern JavaScript, pointing out that many patterns we were used to (like [IIFE](https://en.wikipedia.org/wiki/Immediately-invoked_function_expression) or ["use strict"](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)) are quickly becoming obsolete, while tools like [Webpack](https://webpack.github.io/) and [Babel](https://babeljs.io/) are developer's best friends when working with the latest and experimental JS features across different browsers.

### Day 2

* [Ashley Grant](https://aurelia.ninja/) gave a more or less typical [Aurelia](http://aurelia.io/) talk with standard demo (side note: did you know that [this-is-called-kebab-case](http://wiki.c2.com/?KebabCase)?), except for the last part, where he showed hot module reloading and server-side rendering support implemented just the day before and not released yet. He also mentioned some of their future plans, including Webpack support and an ongoing work on [UI controls](http://eisenbergeffect.bluespire.com/aurelia-interface-update/).

* Most people know [Mark Seemann](http://blog.ploeh.dk/) as the author of a [Dependency Injection in .NET](https://www.manning.com/books/dependency-injection-in-dot-net) book, but since then he moved into the mysterious land of the functional programming. His talk actually combined both worlds, with a very simple question as the main theme: how do you properly implement dependency injection in functional languages? Using examples from C#, F# and Haskell, going through [pure functions](https://en.wikipedia.org/wiki/Pure_function) and [ports and adapters architecture](http://blog.ploeh.dk/2016/03/18/functional-architecture-is-ports-and-adapters/), he demonstrated that the answer is not *partial application* (because it is not functional at heart), but *composition of functions* instead. Very enlightening.

* The all time top StackOverflow guru [Jon Skeet](http://stackoverflow.com/users/22656/jon-skeet) gave an entertaining talk called "Abusing C# More" and, oh boy, yes he can! He easily tricked the audience *and* the compiler with the invisible [mongolian vowel separator](https://codeblog.jonskeet.uk/2014/12/01/when-is-an-identifier-not-an-identifier-attack-of-the-mongolian-vowel-separator/), totally abused the deconstruction feature of C# 7.0, played with operator overloading for IEnumerable (imagine you could use "+", "-" etc. with collections) and did all other kinds of nasty and mostly useless magic which blew my mind. The code examples are available in a [github repo](https://github.com/jskeet/DemoCode).

* [Spencer Schneiderbach](https://schneids.net/) listed the best practices for building REST APIs. Some thoughts were opinionated, others were common sense, but overall it was a good overview, I think. And yes, he recommends using [MediatR](https://github.com/jbogard/MediatR), so thumbs up.

* One day I will write a post about something which, for lack of a better name, I call *a virtual apprenticeship*. For me the most effective learning model these days is to find someone in the industry who I understand and trust, and then follow closely everything they do (I think this very much resembles how people did it last several thousand years, learning from masters by following their example). For me one of these guys is [Jimmy Bogard](https://lostechies.com/jimmybogard/), the autor of AutoMapper and MediatR. Not only I like the tools, but I also always enjoy watching his talks, because usually they *click* with my way of thinking about software development. So, going to his talk about microservices was a no-brainer. It was a funny story about his team's experience migrating a legacy web system at a fictional company *Bell Computers* (ha-ha) to a microservices architecture. There were smart technical decisions and also many organizational quirks and impediments, which resulted in talking about the *Inverse Conway Maneuver* and Jimmy's own extension of Conway's Law.

{{< figure src="/images/jimmys_law.jpg" title="" >}}

* [Sasha Goldshtein](http://blogs.microsoft.co.il/sasha/) threw a lot of low-level technical details about utilizing modern CPU features to improve performance of .NET applications. A famous example of speed comparison when processing a sorted vs unsorted array shows that CPU branch prediction matters and can influence your programs, [SIMD](https://en.wikipedia.org/wiki/SIMD) and vector-based operations allow to do more computational work in the same amount of CPU cycles (and, by the way, .NET Framework 4.6 has [built-in classes with SIMD support](https://msdn.microsoft.com/en-us/library/dn879696)).

* The day ended in the most perfect way possible: I attended a live recording of .NET Rocks show! It was a panel discussion about machine learning with Evelina Gabasova, Barbara Fusinska and Jennifer Marsman, which showed that women in technology are super cool and incredibly smart. And it goes without saying that watching Carl and Richard actually do their magic on stage was just beyond awesome.

### Day 3

* A talk about dockerizing ASP.NET applications happened to be one of the most productive in terms of demos and inspiration. [Elton Stoneman](https://blog.sixeyed.com/) showed a very basic ASP.NET WebForms (!!!) app and then step by step containerized it into a fully distributed set of nicely decoupled microservices, all in one hour! I was very impressed by the quality of the examples, everything looked practical, polished, and ready-to-use. I wish all speakers prepared like this.

* One of those talks I chose by googling the day before, [Simon Brown's](http://simonbrown.je/) approach to visualizing software architecture is no-nonsense, to the point and flexible. His own *C4* model stands for *Context, Containers, Components, Classes*, which are essentially the four different zoom levels when looking down on the architecture (he uses the "diagrams as maps" metaphor all the time). Of course, he has a [book](https://leanpub.com/b/software-architecture) and a [SaaS architecture visualization software](https://structurizr.com/) to support this approach. I also liked his idea of how the software documentation should look like: not a hundred page outdated monstrocity, but a *software guidebook* instead, containing the explanation of how it works, without too many implementation details and possible to read in 1-2 hours maximum.

* I had had high expectations about Bill Wagner's presentation on C# 7.0 pattern matching, but it ended up being one of the most disappointing talks. One third of the time was spent on generic Microsoft open-source roadmap explanation, the second, on struggling with a recent build of Visual Studio 2017, the rest - writing some very, very basic sample code, which didn't go further than anything you can google and try yourself in 5 minutes. I respect everything that Bill has done for the industry over the years, but this time it felt rough and shallow.

* When it comes to talking about Octopus Deploy, [Damian Brady](https://damianbrady.com.au/) is usually the guy to explain it very well. But it seems that he is gradually shifting his area of interest, so this talk was more about implementing DevOps in an organization in general. A lot of very sensible advice, like isolating variations of software, externalizing configuration, measuring in production, deploying without drama, using feature flags, and making the culture change happen. His definition of DevOps is powerful and should be every company's motto, I think. Also, Damian was very friendly and open after the talk, when I bothered him with some Octopus-related questions.

{{< figure src="/images/devops_definition.jpg" title="" >}}

### Conclusion

NDC London 2017 was just awesome; seeing all these smart people at one place gives so much inspiration and feels like being part of something bigger. I guess my budget will be suffering a lot, because I absolutely have to attend more NDC's!