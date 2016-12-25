+++
Categories = []
Description = ""
Tags = []
date = "2016-11-12T15:00:54+01:00"
title = "coffee and links 1"
displaytitle = "Coffee and Links #1"
+++

Sometimes I find interesting things on the web, which don't belong to a single category. Just random articles or news about technology. Since I still want to share these findings and because I normally do this kind of reading at the start of the day, I will be publishing this as a *Coffee and links* digest.

{{< figure src="/images/coffee-and-links-1.jpg" title="" >}}

### News

* [This autumn Microsoft has launched Windows Server 2016](https://blogs.technet.microsoft.com/hybridcloud/2016/09/26/announcing-the-launch-of-windows-server-2016/), with lots of improvements and new features, like [containers support](https://blog.docker.com/2016/09/build-your-first-docker-windows-server-container/) (Docker containers can now natively run on Windows) and [a lightweight GUI-less version called *Nano Server*](https://technet.microsoft.com/en-us/windows-server-docs/get-started/getting-started-with-nano-server) (small, fast, and perfect as a hosting platform).

* Another thing from Microsoft: a new communication platform called [Microsoft Teams](https://products.office.com/en-us/microsoft-teams/group-chat-software), which seems to target the market where [Slack](https://slack.com/) dominates, but has an additional benefit of Office 365 integration. Slack was apparently so scared with this announcement that they posted a public letter to Microsoft, written in a condescending tone and reminding [a famous welcoming letter from Apple to IBM published in Wall Street Journal in 1981](http://aaplinvestors.net/marketing/seriously/). Some people think that [Slack will regret doing this](http://www.theverge.com/2016/11/3/13504932/slack-microsoft-teams-letter-wtf).

* If you have ever passed any Microsoft certification exams, this one might be interesting for you: Microsoft has partnered with [Acclaim](https://www.youracclaim.com/) to provide [a digital badges system](https://www.microsoft.com/en-us/learning/badges.aspx#mcsa) for displaying your certification status. [Showing off has never been easier!](https://www.youracclaim.com/badges/e7345db9-f7c8-4727-b020-3aeceb39b3d6/public_url)

{{< figure src="/images/AcclaimBadge.png" title="" >}}

* If you are still looking into where and how to start using .NET Core, Jon Hilton found a bunch of sample projects to look into and learn from (here's [part 1](https://jonhilton.net/2016/10/12/learning-dotnet-core-by-example/) and [part 2](https://jonhilton.net/2016/11/03/learn-dot-net-core-by-example-part-ii/)). I am definitely going to check these out.

* [Lots of different databases and ORM frameworks already have support for .NET Core](https://blogs.msdn.microsoft.com/dotnet/2016/11/09/net-core-data-access/). Always interesting to see how people abuse (in a good way) different database systems: for example, [Marten](http://dontcodetired.com/blog/post/NET-Document-Databases-with-Marten) is a document database built on top of a relational one ([PostgreSQL](https://www.postgresql.org/)). Actually, [in version 3.0 has Octopus Deploy migrated](https://octopus.com/blog/3.0-switching-to-sql) from [RavenDB](https://ravendb.net/) to SQL Server, but [they creatively use it as a document storage too](https://octopus.com/blog/sql-as-document-store).

### Tools

* [Puma](https://www.pumascan.com/) is a security scanner for Visual Studio built on top of [Roslyn](https://github.com/dotnet/roslyn), which can detect [OWASP](https://www.owasp.org) vulnerabilities by means of static code analysis. It can be installed into a single project as a [NuGet package](https://www.nuget.org/packages/Puma.Security.Rules/) or added globally as a [Visual Studio extension](https://visualstudiogallery.msdn.microsoft.com/80206c43-348b-4a21-9f84-a4d4f0d85007).

* [Intercooler.js](http://intercoolerjs.org/) is an interesting attempt to simplify working with AJAX requests from client-side code. What if you could define which endpoint to call from the markup itself? No viewmodels needed, just like this:
```
<-- This anchor tag posts to '/click' when it is clicked -->
  <a ic-post-to="/click"> Click Me! </a>
```
It allows you to make GET/POST requests, automatically render returned response as HTML inside the corresponding tag, easily integrate with the rest of your JavaScript code and much more (check out the [examples](http://intercoolerjs.org/examples/index.html)). Might be an interesting way of composing the elements of a web application into completely self-sufficient widgets. And it's only 6.74KB gzipped. 

### Fun

* Is there a single geek out there who has never played Pac-Man? If this brings up good memories from your childhood (it absolutely does for me), then you may want to read [a history of the famous game and even some gameplay analysis](http://www.gamasutra.com/view/feature/3938/the_pacman_dossier.php?print=1).

### Other

* [This is the best explanation of video compression I have ever read](https://sidbala.com/h-264-is-magic). It is not a trivial topic at all, but Sid Bala made it super easy to follow and understand with the help of carefully chosen words like *entropy* and *mindfuck*.   