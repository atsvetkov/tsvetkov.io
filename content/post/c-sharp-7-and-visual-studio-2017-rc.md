+++
draft = true
Categories = []
Description = ""
Tags = []
date = "2016-12-25T12:58:59+01:00"
title = "C-Sharp 7.0 and Visual Studio 2017 RC"
displaytitle = "C# 7.0 and Visual Studio 2017 RC"

+++

A new Release Candidate of Visual Studio 2017 [has been released recently](https://www.visualstudio.com/en-us/news/releasenotes/vs2017-relnotes), featuring faster installation and solution loading, an updated project file format, improved IntelliSense, better navigation, and some new built-in refactoring actions covering a significant part of commonly used ReSharper functionality. In this post we will look briefly into these items and also will make a small coding exercise to demonstrate some cool features of C# 7.0.

### Installation

If you want to try it out today, just go to the [Visual Studio 2017 RC page](https://www.visualstudio.com/vs/visual-studio-2017-rc/) and download the installer of a specific edition (I'm testing the Enterprise version). The installer itself is tiny and will download the necessary files on the fly. This is actually an important point: this version of Visual Studio has a slightly different way of configuring features, called [workloads](https://docs.microsoft.com/en-us/visualstudio/install/install-visual-studio#install-workloads) (a pack of related features for a certain type of development work, like web, data science etc.)

{{< figure src="/images/visual-studio-workloads.png" title="" >}}

I selected Web Development workload only, which resulted in a much smaller footprint on the disk: the whole installation folder is now 1.5Gb size, while my current Visual Studio 2015 is occupying more than 5GB. That's a huge win, and it also apparently contributes to the reduced VS starting time.

### New project file format

If you followed the whole story of .NET Core, you know that for the cross-platform version of framework Microsoft came up with [a new JSON-based project file](https://docs.microsoft.com/en-us/dotnet/articles/core/tools/project-json). It was a beautiful idea and a great improvement compared to the old XML craziness of *.csproj. One the coolest parts of the `project.json` are the unified project/package references (basically every dependency is specified as a NuGet package) and convention-based inclusion of source code files (no explicit list of individual files, like it was in the older .csproj format). These changes made the JSON project file shorter and human-readable.

But then came a realization that the old project files were part of the huge ecosystem of existing MSBuild tools, so rewriting *everything* from XML to JSON would be an enourmous effort, not only for Microsoft itself, but also for third-party tools authors. So, long story short, `project.json` is no more, and there is a new and improved .csproj coming. (For a more detailed explanation and reasoning behind this change check out [this Steve Gordon's blog post](https://www.stevejgordon.co.uk/project-json-replaced-by-csproj)).

When you create a new project in Visual Studio 2017 RC, it is already using the *new* .csproj (still an alpha version and subject to change), which looks like this:

{{< gist atsvetkov 4b5e0efdc8612b7746e57f045d2dc37a >}}

{{< figure src="/images/visual-studio-project-file.png" title="" >}}

This is the moment when you say, *"Wait a moment, do I really see you editing the project file and having the project loaded at the same time?"*. Yes! Now we finally don't need to unload the project when manually changing .csproj. This thing alone is a big time-saver, I'm really happy about it.

### C# 7.0 features

