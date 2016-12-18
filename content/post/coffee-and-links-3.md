+++
Categories = []
Description = ""
Tags = []
date = "2016-12-16T21:40:04+01:00"
title = "Coffee and Links - 3"

+++

{{< figure src="/images/coffee-and-links-3.jpg" title="" >}}

### News

* [Google keeps working on self-driving cars](https://www.bloomberg.com/news/articles/2016-12-13/alphabet-creates-new-self-driving-car-business-called-waymo), now as [Waymo](https://waymo.com/), a separate company under [Alphabet](https://abc.xyz/). It's also interesting to read [about the changes in Google's business and internal projects during last years](https://www.bloomberg.com/news/features/2016-12-08/google-makes-so-much-money-it-never-had-to-worry-about-financial-discipline). Despite all the experiments they are doing, a major part of the revenue still comes from advertising. But company leaders claim that this as a tool to achieve more significant goals rather than a goal on its own.

{{< figure src="/images/google_revenue.png" title="" >}}

* Amazon rethinks shopping with [Amazon Go](https://www.amazon.com/b?node=16008589011), getting wireless payments to the next level. I can't wait for this to become mainstream!

* Yahoo reveals that [1 billion user accounts were compromised](https://www.wired.com/2016/12/yahoo-hack-billion-users/), making it *"the biggest known hack of user data ever"*.

* Microsoft wants us to [talk to fridges and toasters](http://www.theverge.com/2016/12/13/13935136/microsoft-cortana-windows-10-iot-devices), integrating Cortana into home devices. Yeah, why not. *Hey, fridge, how much beer is left?*

### Languages and frameworks

* If you are already preparing your New Year resolutions and catching up with JavaScript is on the list, then you might want to check [Top JavaScript Frameworks & Topics to Learn in 2017](https://medium.com/javascript-scene/top-javascript-frameworks-topics-to-learn-in-2017-700a397b711#.qe16jz7ue). Quite opinionated view, but makes a lot of sense. Choosing between top contenders, Angular 2 and Recat, personally I'd bet on and invest into the latter. And if you feel fed up with JavaScript frameworks, maybe refresh the core skills by taking [free 30-day vanilla JavaScript course](https://javascript30.com/).

* At some point most .NET developers have to deal with [reflection](https://msdn.microsoft.com/en-us/library/f7ykdhsy.aspx). And very soon after that they learn that reflection API is slow (by design) and has to be used with caution. [Matt Warren explains why and shows some benchmarks](http://mattwarren.org/2016/12/14/Why-is-Reflection-slow/), demonstrating that, for instance, calling a property getter through a delegate is 8 times slower than the direct invocation, while calling it through reflection is 900 times slower. Always good to be aware of the relative speed.

### Tools

* [BenchmarkDotNet](http://benchmarkdotnet.org/) is an open-source .NET benchmarking library by same Matt Warren, which allows to measure performance of specific methods by marking them with a special attribute and then passing to the benchmark runner class:
```
public class Md5VsSha256
{
        ...
        [Benchmark]
        public byte[] Sha256()
        {
            return sha256.ComputeHash(data);
        }
}
```
```
var summary = BenchmarkRunner.Run<Md5VsSha256>();
```

* Speaking about performance in .NET, too many memory allocations might create a lot of pressure on garbage collector, which will result in frequent collections, stealing precious CPU time. Obviously, some allocations are necessary (like when you are actually *new*ing up an instance of a class), but some are less obvious and can be avoided (boxing, expressions, method arguments marked as *params* etc.). [ReSharper Heap Allocation plugin](http://resharper-plugins.jetbrains.com/packages/Resharper.HeapView.R90/) (or, if you are not using ReSharper, [Roslyn CLR Heap Allocation Analyzer](https://github.com/Microsoft/RoslynClrHeapAllocationAnalyzer)) will highlight all memory allocations, so that you can at least see and evaluate them.

{{< figure src="/images/resharper_heap_allocations.png" title="" >}}

### Fun

* With [Radio Garden](http://radio.garden/live/zoersel/zoe/) you can rotate the globe and pick one of the radio stations playing at a certain geographic point. Pretty cool for someone living abroad and feeling homesick.

{{< figure src="/images/radio_garden.png" title="" >}}

* True emoji should be text-only, so get creative with [Text Emoticon Generator](https://ascii.li/emoticon-creator)!
```
╮(•‿•)╭
```

* There are [over 1 billion websites](http://www.internetlivestats.com/total-number-of-websites/) on the World Wide Web today and the total amount of data online is measured in [exabytes](https://en.wikipedia.org/wiki/Exabyte). So it is particularly funny to see that [the map of the Internet as of May 1973](https://twitter.com/workergnome/status/807704855276122114) would fit on a single sheet of paper.

### Other

* [This article about organizing agile teams](http://techbeacon.com/how-best-organize-agile-teams-build-around-autonomy-mastery-purpose) really resonated with me. I totally agree with the author that good teams are self-sufficient, internally motivated and driven by their own desire to deliver something meaningful.

> *"That’s because people don't work to be agile. People work for their satisfaction. Often, autonomy, mastery, and purpose will satisfy them. Keep people satisfied at the personal level and they will provide the results you want in their team."*

* How do you estimate the total number of German tanks only having several ones captured? [An fascinating application of statistical theory to a very specific problem during World War II](https://en.wikipedia.org/wiki/German_tank_problem).

* TED is publishing a link to a selected talk every day in December, calling it [31 days of ideas](http://www.tedxbasel.com/txb-blog/?tag=31+days+of+ideas). A nice and not-too-time-consuming way to learn ideas from various areas and get inspired. Highly recommended for broadening your horizons.
