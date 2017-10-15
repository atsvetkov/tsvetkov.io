+++
Categories = []
Description = ""
Tags = []
date = "2017-10-15T11:39:48+02:00"
title = "TechDays NL 2017: impressions"

+++

This week I attended my first Microsoft's conference in the Netherlands, [TechDays 2017](https://www.techdays.nl/). It was super exciting to be there and to learn from the top experts in the field. Also, finally got a better overview of the Dutch companies doing software development and consulting with Microsoft technology stack: it's funny how easy it is to keep working in your own bubble after moving to another country.

Without any particular structure, here are my impressions about the conference in general and specific talks I attended.

{{< figure src="/images/techdays-figurine.jpg" title="" >}}

I remember the times when half of cloud-related talks on the conferences were focused on explaining why cloud technologies are a good choice. Nowadays, it seems that everybody already agrees on that, so instead of *why cloud* you see many more *how to do cloud right* sessions. This is perhaps a natural adoption curve which is just reflected in the demands of the audience. It seems that containerization in general and Docker in particular are now in this first stage, since most speakers would be spending good 10-15 minutes explaining what benefits containers bring.

Last January on NDC London there was [a talk by Docker's Elton Stoneman](https://www.youtube.com/watch?v=nw4DBBFilBY), which I really enjoyed (his sessions are really packed with content, not a single minute wasted), so this time I was also happy to join his 2 hour workshop about Docker on Windows. Apparently, this is usually a full-day event, so we only managed to do maybe 30% of all exercises, but still it was a very good practice of configuring and running dockerized apps using Windows containers. By the way, [the whole workshop is freely available on GitHub](https://github.com/sixeyed/docker-windows-workshop), so anyone can try it out (I'm definitely going to finish at home what we started during the session).

Guys from [Xpirit](https://www.xpirit.com/) were also giving excellent talks about Docker and I attended the two-part session about going further with Docker than just F5 in Visual Studio. Well, I would say the title was a bit misleading: first part was a rather high-level overview of containerized development workflow, whereas the second one explained how Docker support in Visual Studio 2017 actually works. And that was a real eye-opener for me: everything was demystified and clarified down to the smallest detail ([Alex Thissen](https://twitter.com/alexthissen) is now one of my favourite speakers in this area).

{{< tweet 918838031234273280 >}}

I learned about security-related features in SQL Server 2016, like dynamic data masking and row-level security. The latter makes so much code I had to write obsolete... which makes me happy! I can totally see how the "content-based authorization" mechanism can be drastically simplified at the company where I am working now.

Another topic which seems to be pretty popular in "advanced" level talks is [Event Sourcing](https://docs.microsoft.com/en-us/azure/architecture/patterns/event-sourcing) (usually combined with [CQRS](https://docs.microsoft.com/en-us/azure/architecture/patterns/cqrs)). This approach can be very helpful in distributed systems and allows to get certain features for free (audit log, replayability) at the cost of others (getting "current state" of data involves more work). As always in software architecture, it's a trade-off. Technology-wise, several presenters discussed these patterns applied to [Service Fabric](https://azure.microsoft.com/en-us/services/service-fabric/), which seems to be gaining more and more popularity.

The main reason for my going to TechDays was [Bart de Smet](https://www.pluralsight.com/authors/bart-desmet), who is currently a Principal Software Development Engineer at Microsoft and is an expert in .NET runtime and languages. In my opinion, he is hands down the best speaker ever when it comes to explaining internals of .NET or C# implementation details. My curiosity was fully satisfied! Bart doesn't waste time at all, so we learned what's really happening behind local functions and lambdas, what magic the Roslyn compiler uses to make pattern matching work in `switch` statements, what performance improvements were made in .NET Core CLR (things like `ArrayPool<T>` and `Span<T>`), shared some real-world performance investigation stories from his experience in Bing team. This is where I started hitting my .NET knowledge limits and got lost somewhere between [finalization queues](https://blogs.msdn.microsoft.com/tom/2008/04/25/understanding-when-to-use-a-finalizer-in-your-net-class/) and [IO completion ports](https://dschenkelman.github.io/2013/10/29/asynchronous-io-in-c-io-completion-ports/) - which is perfectly fine and is the exact reason I go to such talks: it's very important to know what you don't know (yet). Finally, Bart showed us an example of building a custom Roslyn analyzer and a corresponding code fix, which is totally cool and is on the top of my practice list now.

{{< figure src="/images/techdays-stickers.jpg" title="" >}}

Sometimes the sessions were on a familiar topic, but made me look on something from a new angle and ask new questions to myself. *When backend is eventually-consistent and therefore user actions do not always complete synchronously, how to consistently handle updating UI? Since, as it turns out, Docker Swarm supports hybrid clusters with both Linux and Windows hosts, can I migrate my legacy ASP.NET/WCF apps to windows containers, avoiding significant effort of refactoring to .NET Core? Given the flexibility and functional completeness of [Azure API Management](https://azure.microsoft.com/en-us/services/api-management/), should I push for using it for our self-hosted services or borrow the architectural approach and build our own solution?* There's a whole lot more questions and ideas I've written down during these two days, and that's why I like conferences - for tons of inspiration.

I got actually so inspired, that I immediately bought this book:

{{< figure src="/images/hit-refresh.jpg" title="" >}}

So, TechDays is over, but conference season is just starting: next week I'm going to [.NET DeveloperDays](http://net.developerdays.pl/) in Warsaw. Stay tuned!