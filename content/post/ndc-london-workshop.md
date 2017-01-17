+++
date = "2017-01-17T21:14:23+01:00"
title = "NDC London: ASP.NET Core workshop"
Categories = []
Tags = []
Description = ""

+++

{{< figure src="/images/ndc_london_2017_workshops.jpg" title="" >}}

Apparently last year I was a good boy, because Santa has already made several of my dreams come true in 2017. This week I am visiting London and attending [NDC London](http://ndc-london.com/), one of the greatest and most inspiring conferences I am aware of. Until now I only knew it by watching [numerous recorded talks from the past](https://vimeo.com/ndcconferences) and listetning to these top notch developers on [.NET Rocks](https://www.dotnetrocks.com/). Well, this morning I was in an elevator with [Scott Allen](http://odetocode.com/about/scott-allen), whose courses on PluralSight were the major part of my learning materials on ASP.NET some years ago. And when I stepped out of this elevator, first thing I heard was "Hi, I'm Richard Campbell" (that's exactly 50% of .NET Rocks I just met). I know, it sounds silly, but I actually feel like a little boy meeting his all time football idol or somebody like that.

Anyway, enough emotions.

*Hell, I spent last two days on ASP.NET Core workshop with Damian Edwards, David Fowler and Jon Galloway!*

Ok, *now* I'm done with emotions. The workshop started from the very basic concepts (why .NET Core and how it is different) and gradually became more and more in-depth how-to session on various parts of .NET Core ecosystem, including hosting, configuration, tooling, logging, MVC and much more. We even found a couple of bugs in realtime (after all the VS tooling part is still RC)! Besides the sessions in a lecture format, we had a lab after each one, which were available [on github](https://github.com/jongalloway/aspnetcore-workshop). This part felt more like an individual exercise with a priceless bonus of having the authors of the framework in the same room.

It's hardly possible to describe all that we've learned there, because that was *a lot* of information, like really *a lot*. We were taught the differences between running .NET Core apps from Visual Studio and directly from command-line, [how certain environment variables influence the hosting behaviour](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/hosting), how flexible [middlewares](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/middleware) (or middlesware?) are compared to the old HTTP modules/handlers, how to configure [logging](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging) and handle errors locally and on production environment. On the second day we looked into [tag helpers](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/tag-helpers/intro), options for building single-page applications on .NET Core using [Yeoman generators](https://docs.microsoft.com/en-us/aspnet/core/client-side/yeoman) and [ASP.NET Core Template Pack](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.ASPNETCoreTemplatePack), how [JavaScript Services](https://github.com/aspnet/JavaScriptServices) enable cool modern features like hot module replacement and server-side prerendering, and at the end looked at different [publishing workflows](https://docs.microsoft.com/en-us/aspnet/core/publishing/iis) and experimental support of [Application Insights](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-asp-net-core), which is expected to be a super-easy-to-enable feature in Visual Studio 2017. It was also pretty entertaining to see the Microsoft guys ranting about certain Microsoft products and technologies, like IIS or COM, and using Chrome 90% of the time for demos. It just makes me feel better, like it's not just me, they recognize it too.

By the way, most links above point to the new [Microsoft Docs](https://docs.microsoft.com) site, which is a very, very cool new resource. It feels modern and way better than MSDN. Well, it has to be like that, since [Rob Eisenberg is working on it](http://eisenbergeffect.bluespire.com/joining-microsoft/).

It was a great experience and it certainly inspires to create and to share. Now that the pre-conference workshops are over, I'm looking forward to the next three days of talks by guys like Bill Wagner, Troy Hunt, Jon Skeet and Mark Seeman.

Lifelong learning FTW!

And, by the way, London is just fabulous, when it's not raining.

{{< figure src="/images/london_evening_thames.jpg" title="" >}}
