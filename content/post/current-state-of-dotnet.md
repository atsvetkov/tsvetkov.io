+++
Categories = [".NET", "software development"]
Description = ""
Tags = [".NET", "software development"]
date = "2016-10-18T22:22:41+02:00"
title = "Current state of .NET"

+++

Imagine a software developer working in a typical enterprise IT company. Let's call him Johnny. Most of the time Johnny works with .NET applications. He's been writing web apps since the days of ASP (he feels pretty comfortable with Web Forms and IIS after all these years), but he was always too busy doing *important things* and never really had time to follow the news in the industry. Yeah, he heard some folks in another department are using "MVC", and somebody mentioned something like "core" or "standard". And some fellow .NET developers were even talking about Linux at the coffee machine. What? *.NET* and *Linux*? Weird!

Or is it?

Johhny feels that he might have been missing something important going on, but he is a bit afraid to ask his colleagues (after all, his title clear says he is a *Senior Developer*). So Johhny arranges a meeting with Dave, his former colleague, who left the company a long time ago to join some fancy startup. In fact, Johnny thinks that Dave is a total hipster and a nerd obsessed with new shiny frameworks... well, at least they are friends, so it's OK to look less competent. So Johnny asks something like "what's new in .NET" - and Dave opens a whole new world to him.

What could be the most exciting new possibilities in today's .NET ecosystem that Johnny learned about? Let's look at Dave's *Top 5 Reasons Why .NET Is So Awesome Today*:

1. .NET is now [completely open-source](https://github.com/dotnet/), so, for example, if you ever wondered how LINQ's `Count()` method worked, now you can [look it up on GitHub](https://github.com/dotnet/corefx/blob/master/src/System.Linq/src/System/Linq/Count.cs). For example, you can see that before even trying to iterate the whole sequence (which might be time-consuming), they check if this sequence is actually a collection (which preserves a 'Count' property), and if it is, then the collection's `Count` is returned, making it O(1) operation instead of O(n):
```
ICollection collection = source as ICollection;
if (collection != null)
{
        return collection.Count;
}
```

2. The newest version of the framework is called [.NET Core](https://www.microsoft.com/net/core/platform) and is completely cross-platform (not only you can [run .NET apps on Linux](https://docs.asp.net/en/latest/publishing/linuxproduction.html), you can even have the [whole development environment on Linux too](http://piotrgankiewicz.com/2016/10/17/net-on-linux-bye-windows-10/)). And the new command-line tool `dotnet` allows to [scaffold, build and run the application on all platforms](http://www.hanselman.com/blog/ExploringTheNewNETDotnetCommandLineInterfaceCLI.aspx), just like this:
```
dotnet new
dotnet build
dotnet run
```

3. [SQL Server 2016 is going to run on Linux too](https://blogs.microsoft.com/blog/2016/03/07/announcing-sql-server-on-linux), which is exciting news for the companies that want to reduce costs of licencing and hosting.
4. [Next version of C# (7.0)](https://blogs.msdn.microsoft.com/dotnet/2016/08/24/whats-new-in-csharp-7-0/) will contain even more features inspired by functional languages: there will be [pattern matching](https://en.wikipedia.org/wiki/Pattern_matching), real tuples, local functions and deconstruction syntax support. For example, we will be able to write code like this:
```
public void Foo()
{
        // local function
        (string firstName, string secondName) GetTwo()
        {
                // returns a tuple
                return ("Johnny", "Dave");
        }

        // deconstruction into two variables at once
        (var first, var second) = GetTwo();
}
```

5. If just having functional features in an object-oriented language is not enough, you can easily switch to [F#](http://fsharp.org/), a functional language for .NET platform. It is becoming more and more popular in the [finance](http://tomasp.net/blog/2015/why-fsharp-in-2015/) [industry](https://fsharp.tv/gazettes/f-the-most-highly-paid-tech-worldwide-in-2016/) and has frameworks for web development too, like [WebSharper](http://websharper.com/) and [Suave](https://suave.io/).

Obviously this is just the tip of the iceberg. Johnny has a lot to catch up, but he already feels very much inspired. This is clearly not the same .NET world where he started his career many years ago: everything is changing and Microsoft is making .NET a very attractive platform for all kinds of applications. It's a great time to be a .NET developer, so Johnny decides that he needs to meet with Dave more often, read more developer-oriented resources and also try some new shiny stuff out.

Be like Johnny! Embrace change and learn amazing things!

*(For some suggestions about which news to follow, take a look into my previous post about [Staying up-to-date with software development trends](/2016/10/staying-up-to-date-with-software-development-trends/))* 