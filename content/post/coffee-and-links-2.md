+++
Categories = []
Description = ""
Tags = []
date = "2016-11-19T14:17:47+01:00"
title = "Coffee and Links - 2"

+++

This was a week of [Microsoft Connect 2016](https://connectevent.microsoft.com), an event where yet another bunch of cool announcements were made. However, being a good software engineer means not restricting yourself to a single technology, so I have some awesome non-Microsoft things to share as well. Let's jump straight in!

{{< figure src="/images/coffee-and-links-2.jpg" title="" >}}

### News

* Microsoft used to be one of those companies on the far end on the "opensourceness" spectrum, and .NET itself seemed to be almost an antonim of "open source". These days are gone! Just look at this: [Microsoft is joining the Linux Foundation](https://techcrunch.com/2016/11/16/microsoft-joins-the-linux-foundation/), while [Google is joining the .NET Foundation](https://cloudplatform.googleblog.com/2016/11/Google-Cloud-to-join-NET-Foundation-Technical-Steering-Group.html). Generally this means that both companies are getting more and more committed to contributing to the open source tools and products from both worlds, which is amazing news for all developers. It is not that crazy or surprising, though, given that [PowerShell now runs on Linux](https://azure.microsoft.com/en-us/blog/powershell-is-open-sourced-and-is-available-on-linux/), [SQL Server preview runs on Ubuntu](https://insights.ubuntu.com/2016/11/16/microsoft-loves-linux-ubuntu-available-on-sql-server-public-preview) and [Google Cloud supports ASP.NET web applications](https://cloudplatform.googleblog.com/2016/08/making-ASP.NET-apps-first-class-citizens-on-Google-Cloud-Platform.html). It's all so mixed up now... which is awesome!

* Visual Studio 2017 Release Candidate (formerly known as Visual Studio 15) [is now available](https://msdn.microsoft.com/magazine/mt790181). There are lots of productivity and performance improvements, for example, solutions and projects should be loading 2-4 times faster than in VS 2015. I'm really looking forward to it, as well as to the [new language features of C# 7.0](https://msdn.microsoft.com/magazine/mt790184). And finally there is [Visual Studio for Mac](https://msdn.microsoft.com/magazine/mt790182)! Not that I am personally going to use it, but it is just cool to see how Microsoft can leverage existing open-source tools to expand into the new market (VS for Mac is built on top of [MonoDevelop](http://www.monodevelop.com/) and VS Code - on top of [Atom](https://atom.io/)).

* [ASP.NET Core 1.1](https://blogs.msdn.microsoft.com/webdev/2016/11/16/announcing-asp-net-core-1-1/) is released, featuring even higher performance rating on [TechEmpower](https://www.techempower.com/blog/2016/11/16/framework-benchmarks-round-13/), URL rewriting, response caching, Web Listener server on Windows (can be used instead of Kestrel to utilize Windows-specific features) and more. It is still based on project.json file, but there are already working on switching back to .csproj and msbuild - a much improved version of a familiar tooling (more details on the alpha version of this [here](https://blogs.msdn.microsoft.com/dotnet/2016/11/16/announcing-net-core-tools-msbuild-alpha/)).

* Jimmy Bogard, the creator of [AutoMapper](https://github.com/AutoMapper/AutoMapper) and [MediatR](https://github.com/jbogard/MediatR), has updated his sample project [Contoso University](https://github.com/jbogard/contosouniversitycore) to .NET Core. It shows how to use all these fancy tools together, applying [CQRS](http://martinfowler.com/bliki/CQRS.html) pattern and NOT overengineering the solution structure (Jimmy is a big advocate of using a simpler setup and [preferring folders over projects for layering](https://lostechies.com/jimmybogard/2012/08/30/evolutionary-project-structure/)). I really like the way he looks into the common software development problems and finds reasonable no-nonsense solutions. He is also an excellent speaker, so when you have time, watch some of his [NDC talks](https://vimeo.com/search?q=jimmy+bogard).

### Languages and frameworks

* [Eve: Programming designed for humans](http://programming.witheve.com/) - quite an unusual approach to designing a programming language and an IDE together to provide a unique and human-friendly experience. Perhaps not for every project, but certainly interesting for some.

* [Vue.js](https://vuejs.org/), yet another JavaScript framework rapidly gaining popularity, [has recently got a new 2.0 release](https://medium.com/the-vue-point/vue-2-0-is-here-ef1f26acf4b8#.w0mmh55at). I like the philosophy behind it, especially the idea of a *progressive framework*, which allows you to start quickly with the smallest subset of features and only add more when your application has grown big enough. The author, Evan You, explains this nicely in [his talk at UtahJS conference](https://www.youtube.com/watch?v=pBBSp_iIiVM).

* If you want more functional programming features in your .NET code, but switching to F# is not an option, there is [C# Functional Language Extensions](https://github.com/louthy/language-ext) project to the rescue. Using [static usings from C# 6.0](http://geekswithblogs.net/BlackRabbitCoder/archive/2015/04/16/c.net-little-wonders-static-using-statements-in-c-6.aspx) in a clever way, this library allows you to write code that looks and feels pretty much like F# or any other functional language:
```
List<int> items = List(1,2,3,4,5); // static method as constructor function instead of your typical 'new List'
var x = map(opt, v => v * 2); // static method to mimic a globally available 'map' function as a primitive
```

### Tools

* Even in the latest version the IIS Manager tool still looks terribly outdated and doesn't exactly provide a nice user experience. Fear not! There is now a new web-based tool for managing IIS, which provides a full-blown REST API and a default Angular-based web UI for that purpose. Check out the [Microsoft IIS Administration Preview](https://blogs.iis.net/adminapi/microsoft-iis-administration-api-preview). This looks so much more like it's 2016 today, doesn't it?
{{< figure src="/images/iis_manager_preview.png" title="" >}}

### Fun

* *"90% of everything is crap"*, *"Communication usually fails, except by accident"* and other wittyful observations in [15 Fundamental Laws of the Internet](https://www.exceptionnotfound.net/15-fundamental-laws-of-the-internet/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+ExceptionNotFound+%28Exception+Not+Found%29).

* Some kind of Google neural network will try to recognize what you are drawing: [Quick, draw!](https://quickdraw.withgoogle.com/)

### Other

* [You are not paid to write code](http://bravenewgeek.com/you-are-not-paid-to-write-code) - a very nice read about the essence of programming and risks of having engineers build and maintain systems just for the sake of systems, not to solve a real business problem.

> *"But if you set up a system, you are likely to find your time and effort now being consumed in the care and feeding of the system itself. New problems are created by its very presence. Once set up, it won't go away, it grows and encroaches."*

* * *

P.S. Usually I write these posts in VS Code, just because the whole blog is stored in a github repository, so it is kind of natural to treat is as a code base. However, I always enjoy pushing myself out of the comfort zone and optimizing the coding experience. That's why I am now learning to use [Vim](http://www.vim.org), a text editor which is more common in Unix OS, but can be used anywhere. The general idea, as I see it, is to keep your fingers on the home row of the keyboard and minimize unnecessary movement. Learning curve is quite steep, but the benefits are tempting. So in fact this entire post has been authored in Vim (at least doubling the writing time)! And you don't necesssarily have to use the old-school console version, there is [an extension for Visual Studio](https://marketplace.visualstudio.com/items?itemName=JaredParMSFT.VsVim) and [one for Visual Studio Code too](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim), which emulate Vim-like keybindings. Check it out and don't forget: to quit Vim, you type `:wq!`.

{{< figure src="/images/twitter_vi.png" title="" >}}
