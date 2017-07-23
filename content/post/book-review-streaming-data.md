+++
date = "2017-07-23T01:00:00+02:00"
title = "Book review: Streaming Data by Andrew G. Psaltis"
displaytitle = "Book review: \"Streaming Data\" by Andrew G. Psaltis"
Categories = []
Tags = []
Description = "Book review: Streaming Data by Andrew G. Psaltis"

+++

[{{< figure src="/images/book_cover_streaming_data.png" title="" >}}](https://www.manning.com/books/streaming-data)

This book was released in May of this year and seems to have arrived just in time for me. I have been getting more and more involved into architecting the software platform at my current employer, so proper integration of our analytics services with other applications is constantly on my radar. But, at the same time, I didn't want yet to get overwhelmed by all the specifics of [Kafka](https://kafka.apache.org/), [Spark](https://spark.apache.org/), [Storm](http://storm.apache.org/) etc. What I needed was a high-level overview of patterns and solutions in this field, without going into too much detail about specific frameworks, and I feel that *Streaming Data* solves this task perfectly.

As the author himself says in the preface, his career in data streaming systems has always been driven by "large data and need for speed". So, you can expect the book to be focused on explaining how to design high-performance systems for efficient data processing. Starting from showing a blueprint of a typical architecture for such systems, Andrew carefully walks us through data collection, messaging, analysis, storage and other tiers, showing the potential bottlenecks, points of failure and trade-offs in each of them. I really appreciate the attention he puts into these topics, with various ideas about mitigating failures on every step and examples of how existing open-source systems do this.

Chapter 5 about data analysis algorithms is particularly interesting for understanding what you can actually do with a never-ending stream of data. A typical *Computer Science 101* course would only teach you algorithms and data structures for dealing with finite data sets, but streams force you to think completely differently, since you just can't expect to have all your data in one place at once. After reading this chapter, I was finally able to get my head around [Bloom filter](https://en.wikipedia.org/wiki/Bloom_filter), [HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog) and [Count-Min Sketch](https://en.wikipedia.org/wiki/Count%E2%80%93min_sketch) (although I won't claim that I could use any of them now).

Since the book is designed to be an introduction to the topic (216 pages), you can only explain so much for every problem area, and therefore there are a lot of links to other books, papers and articles. So, whenever a reader needs more detail, there is plenty of suggestions of where to start from. And, since actual code can often demonstrate the concept even better than words, Part 2 of the book contains a very detailed code example of building a streaming data system using Java and some Apache frameworks (even being a .NET developer, it was easy to follow the code examples).

I must say, however, that I didn't always like the writing style itself, where same thoughts would sometimes be repeated several times. There is also quite an impressive number of typos for just two hundred pages, which is not very common for Manning books.

*Streaming Data* should be a great read for people interested in an introduction to the topic of real-time analytics systems, it can be very helpful (as it was for me) if you don't have any hands-on experience with Spark, Kafka and other related buzzwords yet.