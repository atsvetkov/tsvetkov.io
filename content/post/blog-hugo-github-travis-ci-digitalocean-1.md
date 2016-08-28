+++
date = "2016-08-28T23:01:21+02:00"
draft = false
description = ""
title = "Building a blog with Hugo, GitHub, Travis-CI and DigitalOcean - Part 1"
tags = ["hugo", "travis-ci", "github", "digitalocean"]
+++

*With great power comes great responsibility*, they say. In case of being a programmer, this sometimes means that achieving simple things may get complicated. I understand that WordPress essentially won as the blogging platform and you can setup your hosted blog in almost no time... but then where is all the fun? On the other hand, putting on a pragmatic programmer's hat, I don't really have time or desire to write my own blog engine either. So I was looking for some kind of a middle ground.

To me the sweet spot seems to be in the static site generators: with this approach you usually get a high performance of a simple static site together with the beauty of Markdown, while still maintaining a freedom to choose how to store the sources and deploy the end result.

Selecting a specific engine is just a matter of taste, I guess, as there are plenty of them these days. Checking out the [Top Open-Source Static Site Generators](https://www.staticgen.com) helped me a great deal to pick one. Most of the time I am a .NET developer (apparently not the most popular stack for blog engines, although there are [several](https://github.com/Code52/pretzel) [quite](https://github.com/Wyamio/Wyam) [interesting](https://github.com/mikoskinen/graze) [ones](https://github.com/Kelindar/misakai-baker)), but I am also starting to learn some [Go](https://golang.org/) this year, so after some quick experiments I chose [Hugo](https://gohugo.io/). The project has over 10K stars on GitHub and promises to *"make the web fun again"*.

Hugo (as well as most other static site generators) allows you to write posts in Markdown format, so you sources are very readable. It can then build your site, which will result in static HTML pages. This basically means that writing the posts is super easy, while serving the content is as fast as it can be, since there is no server-side processing involved. So, in the simplest workflow, you can write a post in Markdown, build the updated version of the site locally and then somehow copy the updated files to wherever the blog is hosted.

Sounds easy, but not automated enough. Part of my daily job is maintaining Continuous Integration pipeline for multiple teams, so I would rather treat a blog as any other code, meaning that is needs to be source-controlled and hosting environment has to be automatically updated on every push. In the next part of this series I will explain how I achieved this using [GitHub](https://github.com), [Travis CI](https://travis-ci.org/) and [DigitalOcean](https://www.digitalocean.com/).
