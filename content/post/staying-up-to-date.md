+++
date = "2016-10-16T16:51:55+02:00"
draft = false
description = ""
title = "Staying up-to-date with software development trends"
tags = ["learning", "tech lead"]
+++

Earlier this year I was assigned to a role of a technical lead in a small development team. This happened after working in the same team for more than a year and then being a part of a two-person architecture team focused on evaluating the microservices approach for a couple of months. At my current employer things are changing quickly and people are free to figure out what the idea actually was. So I am still looking for the meaning of the tech lead role, but definitely enjoying it already.

The *lead* word in the role's name assumes knowledge about how to write good software and other related things. In my opinion, this is a sum of three parts:

1. taking responsibility
2. applying experience
3. constantly learning
  
Part #1 is all about making a decision, taking a well-measured risk and being ready to fail. Evaluating the options and picking one with all potential consequences, be they good or bad - this is what makes a leader (I think I read this in [*Herding Cats: A Primer for Programmers Who Lead Programmers* by J. Hank Rainwater](http://www.apress.com/9781590590171)). This is hard and needs to be supported by the organizational culture. Luckily, at my current company this is one of the core and officially promoted habits: *We make mistakes and learn*. Which is also a life-saver for new hires - nothing encourages more than a feeling of a non-blaming atmosphere around.

Part #2 may sound obvious, but in fact it has to be an explicit *action*. Experience won't manifest itself, you need to actively recognize a familiar pattern, a similar failure or success in the past. Again, the effectiveness of this may depend on the team spirit and organizational values. If there is no trust in the team, then people won't feel like sharing their stories. And it is absolutely necessary to explain the why's, not just make a statement. Compare "nooo, we shouldn't use shared databases, everyone knows that" with "when we had a database shared by three apps on my last project, it resulted in regular deployment failures, finger-pointing and required a lot of cross-team communication". I used to work with a super-smart developer, who also happens to be quite grumpy and hard-to-read. He would just say things like "Octopus Deploy? Bad idea. We tried it before, didn't work out." - and would not elaborate further. Statements like this don't help, they only discourage others from trying something new, because *this guy probably has already tried this too and... right, it was a bad idea*. So applying experience may require surprisingly more communication and effort than one might expect. Buf if done right, this is what makes all the difference between a poor product and a great one. Because, you know, experience is just a list of mistakes you won't make again.

Now, I was originally going to write only about part #3 in this post, so let's finally get to it! For me the best way to describe it would be the current slogan of [PluralSight](https://www.pluralsight.com/), one of my favourite educational video platforms: *Smarter than yesterday*. That is it. And this is what I've been trying to do so far in my career. You don't need to go underwater for a year, memorize all GoF design patterns, complete tutorials for every JavaScript framework out there or read all the books on DDD. (One could argue that this would even be counter-productive, since learning abstract ideas without real-world practice will not really help in solving a real-world problem, at least not in our industry.) It is not too hard to read one good article every day, but it can help accumulate tremendous knowledge in the long run. What is also very important, in my opinion, is to get out of your comfort zone and look beyond your typical technology stack. I generally work with .NET web applications, and yet I try to follow the news and blogs on F#, Elixir, Go and node.js. Why? Because thinking in different languages makes me better understand familiar programming concepts and also learn completely new ones, which are not idiomatic to C#, for example. (And also because you never know what your next job might be.)

In the previous paragraph I mentioned reading *good* articles. The Internet is big, so searching for good stuff can be a daunting task. Most people end up with a relatively stable list of resources for daily/weekly reading. Here's mine (not claiming to be unique or better than any other list):

### Newsletters
* [C# Digest](http://csharpdigest.net/)
* [Elixir Digest](http://elixirdigest.net/)
* [React Digest](http://reactdigest.net/)
* [F# Weekly](https://sergeytihon.wordpress.com/)
* [DDD Weekly](http://dddweekly.com/)
* [Azure Weekly](http://azureweekly.info/)
* [Elixir Radar](http://plataformatec.com.br/elixir-radar)
* [Go Newsletter](http://golangweekly.com/)
* [DevOps Weekly](http://www.devopsweekly.com/)
* [Web Operations Weekly](http://webopsweekly.com/)
* [Microservice Weekly](https://microserviceweekly.com/)
* [Docker Weekly](https://www.docker.com/newsletter-subscription)

### Blogs
* [.NET Blog](https://blogs.msdn.microsoft.com/dotnet/)
* [.NET Web Development and Tools Blog](https://blogs.msdn.microsoft.com/webdev/)
* [Microsoft Application Lifecycle Management](https://blogs.msdn.microsoft.com/visualstudioalm/)
* [Microsoft Azure Blog](https://azure.microsoft.com/en-us/blog/)
* [The Visual Studio Blog](https://blogs.msdn.microsoft.com/visualstudio/)
* [Visual Studio Code Blog](http://code.visualstudio.com/blogs/)
* [Scott Hanselman](http://www.hanselman.com/blog/)
* [Ode to Code (K. Scott Allen)](http://odetocode.com/)
* [Rick Strahl](https://weblog.west-wind.com/)
* [You've Been Haacked (Phil Haack)](http://haacked.com/)
* [.NET Escapades (Andrew Lock)](http://andrewlock.net/)
* [CodeOpinion (Derek Comartin)](http://codeopinion.com/)
* [Exception Not Found (Matthew P Jones)](https://www.exceptionnotfound.net/)
* [Fritz on the Web (Jeffrey Fritz)](http://www.jeffreyfritz.com/)
* [Kévin Chalet](http://kevinchalet.com/)
* [Laurent Kempé](http://laurentkempe.com/)
* [Dominick Baier](https://leastprivilege.com/)
* [Talking Dotnet](http://www.talkingdotnet.com/)
* [The Codeface (Mark Rendle)](https://blog.rendle.io/)

### Podcasts
There is only one item here, because my commute to work is quite short. But seriously, if you work in software development (especially in .NET) and you have time for one podcast only, it has to be [.NET Rocks](http://www.dotnetrocks.com/). Richard and Carl are great hosts and their guests always happen to be exceptionally good at something. After so many shows their voices sound so familiar that I'm almost starting to think of them as my colleagues. And it is very likely that I will meet them alive on [NDC London 2017](http://ndc-london.com/) (which will probably be a reason for a separate post).

This is not to say that everyday I follow *only these* or *all of these*, but this list seems to be the core of my reading and learning process. Let me know what your favourite learning resources are in the comments.

Thanks for reading!