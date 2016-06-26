+++
date = "2016-06-19T18:39:21+02:00"
draft = true
description = ""
title = "Building a blog with Hugo, GitHub, Travis-CI and DigitalOcean - Part 1"
tags = ["hugo", "travis-ci", "github", "digitalocean"]
+++

*With great power comes great responsibility*, they say. In case of being a programmer, this sometimes means that simple things may get complicated. I understand that WordPress essentially won as the blogging platform and you can setup your hosted blog in almost no time... but then where is all the fun? On the other hand, putting on a pragmatic programmer's hat, I don't really have time or desire to write my own blog engine either. So I was looking for some kind of a middle ground.

To me the sweet spot seems to be in the static site generators: with this approach you usually get a high performance of a simple static site together with the beauty of Markdown, while still maintaining a freedom to choose how to store the sources and deploy the end result.

Selecting a specific engine is just a matter of taste, I guess, as there are plenty of them these days. Checking out the [Top Open-Source Static Site Generators](https://www.staticgen.com) helped me a great deal to pick one. Most of the time I am a .NET developer (apparently not the most popular stack for blog engines, although there are [several](https://github.com/Code52/pretzel) [quite](https://github.com/Wyamio/Wyam) [interesting](https://github.com/mikoskinen/graze) [ones](https://github.com/Kelindar/misakai-baker)), but I am also starting to learn some [Go](https://golang.org/) this year, so after some quick experiments I chose [Hugo](https://gohugo.io/). The project has over 10000 stars on GitHub and promises to *Make the Web Fun Again*.

* choosing static HTML blog engine (https://www.staticgen.com/)
* why Hugo and how Hugo works
* (?) choosing domain and hosting, Namecheap
* site structure on Github, forking theme (for safety)
* automation workflow using Travis CI, useful articles I used
* next steps: automating hosting OS configuration from scratch, like SSH key generation, Nginx stuff etc. 