+++
Categories = []
Description = ""
Tags = []
date = "2017-07-03T18:11:53+01:00"
title = "coffee and links 7"
displaytitle = "Coffee and Links #7"

+++

{{< figure src="/images/coffee-and-links-7.jpg" title="" >}}

### .NET Core 2.0 Preview and Visual Studio 2017 15.3 Preview

Microsoft has published [Preview 2 release of .NET Core](.NET Core 2.0 Preview 2), with several improvements to CLI and, of course, to [ASP.NET Core as well](https://blogs.msdn.microsoft.com/webdev/2017/06/28/introducing-asp-net-core-2-0-preview-2/). For instance, running `dotnet build/run/publish` now implicitly restores the dependencies, whereas before is had always to be a separate `dotnet restore` command. There are also plenty of performance optimization work being done in RyuJIT compiler for .NET Core 2.0 and .NET Framework 4.7.1 and [here's a great article with some detailed explanations of these improvements](https://blogs.msdn.microsoft.com/dotnet/2017/06/29/performance-improvements-in-ryujit-in-net-core-and-net-framework/).

There is also a fresh [Visual Studio 2017 15.3 Preview](https://www.visualstudio.com/en-us/news/releasenotes/vs2017-Preview-relnotes), which contains updated ASP.NET Core project templates with several SPA options:

{{< figure src="https://msdnshared.blob.core.windows.net/media/2017/06/AspNetCore2-2-1024x668.png" title="" >}}

By the way, if you can't wait until C# 7.1 features are released, you can play with some of them in this Preview version of Visual Studio too. Language versioning will be separate from IDE versioning in future, so C# 7.1 can be enabled just for one project - isn't that cool? As far I understand, the idea here is to empower developers who want the latest language features as early as possible, while still providing the majority a stable default. (More on that - in a future post.)

### Community standups

I follow [ASP.NET Community Standups](https://live.asp.net/) for more than a year already, and I can recommend this to every enthusiastic .NET developer. It's not just about seeing Microsoft as an open company and not just about learning what to expect in the next release. Another huge value there is in listening how really smart software engineers discuss their technical decisions, motivations and thinking process. In a way it is similar to reading the source code of a well-designed project, but this gives yet another dimension to it: not only you see *what* they did, but also get to hear *why*. Following such public discussions can give you a unique opportunity in future to be able to answer the eternal question, *"what were they thinking?!!"*

I see other companies adopting this way of becoming transparent and catching community's attention: [guys from Octopus Deploy do it](https://www.youtube.com/playlist?list=PLAGskdGvlaw39U9Ed9HhAHEr_AI3xNg56) (that's another one I closely follow, since Octopus is one of my favourite continuous delivery tools) and [Humanitarian Toolbox AllReady project as well](https://www.youtube.com/channel/UCMHQ4xrqudcTtaXFw4Bw54Q/videos).

### Software conferences in 2017

In January 2017 I was extremely lucky to attend NDC conference in London (I blogged about it [here]({{< relref "post/ndc-london-talks.md" >}}) and [there]({{< relref "post/ndc-london-workshop.md" >}})). That really triggered me to make going to conferences a regular activity, because it gives a huge knowledge and enthusiasm boost (I am yet to start paying more attention to networking as well). Unfortunately, I couldn't go to NDC Oslo last month, so I started planning for other events later during the year. I wish I could attend all of them, but can only afford few, so this selection process is quite painful. But sometimes magic happens. This morning I found this email in my inbox:

{{< figure src="/images/dotnetweekly-email.png" title="" >}}

This is officially the first time I ever won anything in a lottery! I was very surprised and am very grateful to people behind [dotNET Weekly](https://www.dotnetweekly.com/), who organized this free conference pass giveaway together with [.NET DeveloperDays](http://net.developerdays.pl/). So, in October I'm going to Warsaw to get another portion of .NET knowledge!

{{< tweet 881484183067131904 >}}

If you are like me (that is, you live in Europe and want to attend as many software conferences as your employer/bank account can handle), here is the list of notable events to pick from in the rest of 2017:

* [DEVIntersection Europe, 18-19 September, Stockholm](https://www.devintersectioneurope.com/#!/): promises to bring some great speakers from Microsoft, including Mads Torgersen and Scott Hunter.
* [GOTO Conference 2017, 1-3 October, Copenhagen](https://gotocph.com/2017): I've always enjoyed watching records from these conferences, sometimes even Martin Fowler speaks there. It is always a mix of tech and "agile" kind of talks, which makes it well-balanced. This year there's going to be Adrian Cockroft, Dan North, and Mark Seeman - more than enough to make anyone a better developer.
* [O’Reilly Software Architecture Conference, 16–18 October, London](https://conferences.oreilly.com/software-architecture/sa-eu): all things architecture from the most prominent professionals, like Sam Newman, Neal Ford, and Simon Brown.
* [.NET DeveloperDays, 18-20 October, Warsaw](http://net.developerdays.pl/): a bit smaller that other big names, but still gathers cool people. For a long time I wanted to watch Dino Esposito's talk - and finally I'm getting a chance!
* [SDD Deep Dive, 7-9 November, London](https://sddconf.com): Software Design & Development conference itself happens in Spring, but there will be a dedicated workshop version in November. Kathleen Dollard, Dominick Baier, Jeff Procise - these are the people you want to listen to on any conference, but a hands-on training with them is just pure gold.

This is going to be an awesome conference season, and since I'm trying to improve my networking skills, dear reader, let me know if you are planning to attend any of the above and let's have a chat there!