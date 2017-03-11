+++
Categories = []
Description = ""
Tags = []
date = "2017-03-11T18:11:53+01:00"
title = "coffee and links 6"
displaytitle = "Coffee and Links #6"

+++

{{< figure src="/images/coffee-and-links-6.jpg" title="" >}}


### Visual Studio 2017 released

The most significant event of this week was, of course, the [launch of Visual Studio 2017](https://www.visualstudio.com/en-us/news/releasenotes/vs2017-relnotes) by Microsoft. If you haven't downloaded it yet, [go ahead](https://www.visualstudio.com/downloads/)! As promised, it really has a lot of improvements, like faster installation, shorter startup time, lightweight solution load, and much more.

Code navigation and built-in refactorings are so good now, that first time in about 10 years I feel pretty comfortable without ReSharper. Seriously, last four days I've been coding without any third-party extensions and the only extra effort I had to make was pressing *Ctrl+.* instead of so familiar *Alt+Enter* (muscle memory strikes back here). I'm really curious to see what the future of ReSharper will be, given that [a rewrite to support Roslyn is not going to happen](https://blog.jetbrains.com/dotnet/2014/04/10/resharper-and-roslyn-qa/) and that [CodeRush](https://www.devexpress.com/products/coderush/) (a competing product from DevExpress) is already built on top of Roslyn platform. Perhaps, the main focus of JetBrains for .NET platform will be [a new IDE called Rider](https://www.jetbrains.com/rider/)? We'll see.

Another example of an improvement that makes a third-party tool kind of obsolete is [live unit testing feature](https://blogs.msdn.microsoft.com/visualstudio/2017/03/09/live-unit-testing-in-visual-studio-2017-enterprise/). It does exactly what you'd think: continously runs the unit tests related to the code you are changing in the background (test projects can be included/excluded individually, which is important when there are integration tests in the same solution). And while [NCrunch](http://www.ncrunch.net/) has been the leading tool in this area this for years, I wonder if it is that relevant anymore. Of course, with live unit testing only available in VS 2017 Enterprise, lots of individual developers might still find NCrunch more affordable, so it will probably retain its niche.

### C# 7.0, .NET Core, DevOps

Of course, it wasn't only about Visual Studio, and many other announcements were made. [C# 7.0](https://blogs.msdn.microsoft.com/dotnet/2017/03/09/new-features-in-c-7-0/) came out too, bringing all the neat new features (I already highlighted some of them [in one of my previous blog posts](/2016/12/c-sharp-7.0-and-visual-studio-2017-rc/)). [Tooling for .NET Core](https://blogs.msdn.microsoft.com/dotnet/2017/03/07/announcing-net-core-tools-1-0/) finally hit version 1.0.0, which was a milestone long-awaited by many .NET Core early adopters. After the two year journey through *ASP.NET vNext*, *ASP.NET 5*, *Project K*, *DNX* and various betas and RCs of *.NET Core*, finally seeing this output in the console is very satisfying:

{{< figure src="/images/dotnet-version.png" title="" >}}

In ASP.NET Core area, there is now an easy support for using Docker containers (even debugging dockerized applications!), default web project templates now include frontend assets using [Bower](https://bower.io/) (in the past all JavaScript files used to be just fixed versions, without any package management), debugging client-side code is now possible in Chrome as well as IE, and an immensely popular [Web Essentials](http://vswebessentials.com/) extension pack [has been updated for VS 2017 too](http://madskristensen.net/post/long-live-web-essentials).

A lot of improvements were also made in DevOps area. How about [configuring CI/CD pipeline with Visual Studio Team Services](https://blogs.msdn.microsoft.com/visualstudio/2017/02/06/continuous-delivery-tools-extension-visual-studio-2017/) right from Visual Studio itself? As always, Microsoft makes this kind of things ridiculously easy, so there is no excuse for not using the best practices of agile software development anymore. Also, [a new partnership with RedGate was announced](https://www.red-gate.com/blog/database-lifecycle-management/visual-studio-2017-redgate-data-tools), giving the users of Visual Studio 2017 Enterprise several built-in extensions, like [ReadyRoll](http://www.red-gate.com/products/sql-development/readyroll/entrypage/microsoft-and-readyroll), a tool for managing database migrations in a very natural database-first way (for example, with [DbUp](https://dbup.github.io/) you would write the migration scripts as the first step and only then apply the changes, while with ReadyRoll you make changes to the local development database first and then tell the tool to generate the diff script).

All these new features and many more were covered in the [keynote](https://channel9.msdn.com/Events/Visual-Studio/Visual-Studio-2017-Launch/100) and [deep dive sessions](https://channel9.msdn.com/Events/Visual-Studio/Visual-Studio-2017-Launch) on Channel 9, and also there is [a new episode about Visual Studio 2017 on .NET Rocks](https://www.dotnetrocks.com/?show=1422). So, if you want to know more, go ahead - watch, listen, and of course try Visual Studio 2017 with C# 7.0 yourself, because it is seriously cool!

### Bonus link

If you already started using VS 2017, you might have been wondering why the new icon looked so different from the previous versions:

{{< figure src="/images/vs-2017-icon.png" title="" >}}

To satisfy this curiosity of yours and mine, Visual Studio team has published a blog post explaining the design process and reasoning behind this choice, with a rather romantic title ["Iterations on infinity"](https://blogs.msdn.microsoft.com/visualstudio/2017/03/08/iterations-on-infinity/).