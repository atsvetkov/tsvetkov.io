+++
Categories = []
Description = ""
Tags = []
date = "2016-12-25T12:58:59+01:00"
title = "C-Sharp 7.0 and Visual Studio 2017 RC"
displaytitle = "C# 7.0 and Visual Studio 2017 RC"
+++

A new Release Candidate of Visual Studio 2017 [has been released recently](https://www.visualstudio.com/en-us/news/releasenotes/vs2017-relnotes), featuring faster installation and solution loading, an updated project file format, improved IntelliSense, better navigation, and some new built-in refactoring actions covering a significant part of commonly used ReSharper functionality. In this post we will look briefly into these items and will also do a small coding exercise to demonstrate some cool features of C# 7.0.

### Installation

If you want to try it out today, just go to the [Visual Studio 2017 RC page](https://www.visualstudio.com/vs/visual-studio-2017-rc/) and download the installer of a specific edition (I'm testing the Enterprise version). The installer itself is tiny and will download the necessary files during the installation. This is actually an important point: this version of Visual Studio has a slightly different way of configuring features, called [workloads](https://docs.microsoft.com/en-us/visualstudio/install/install-visual-studio#install-workloads) (a pack of related features for a certain type of development work, like web, data science etc.)

{{< figure src="/images/visual-studio-workloads.png" title="" >}}

I selected "Web development" workload only, which resulted in a much smaller footprint on the disk: the whole installation folder is now 1.5Gb size, while my current Visual Studio 2015 is occupying more than 5GB. That's a huge win, and it also apparently contributes to the reduced VS starting time.

### New project file format

If you were following the whole .NET Core story, you know that for the cross-platform version of the framework Microsoft came up with [a new JSON-based project file](https://docs.microsoft.com/en-us/dotnet/articles/core/tools/project-json). It was a beautiful idea and a great improvement compared to the XML craziness of the old *.csproj. One the coolest parts of the `project.json` is a unified system of project/package references and convention-based inclusion of source code files (no explicit list of individual files, like it was in the older .csproj format). These changes made the JSON project file relatively short and human-readable.

But then came a realization that the old project files were part of the huge ecosystem of existing MSBuild tools, so rewriting *everything* from XML to JSON would be an enourmous effort, not only for Microsoft itself, but also for third-party tools authors. So, long story short, `project.json` is no more, and there is a new and improved .csproj format coming. (For a more detailed explanation and reasoning behind this change check out [this Steve Gordon's blog post](https://www.stevejgordon.co.uk/project-json-replaced-by-csproj)).

When you create a new project in Visual Studio 2017 RC, it is already using the *new* .csproj ([still an alpha version](https://blogs.msdn.microsoft.com/dotnet/2016/11/16/announcing-net-core-tools-msbuild-alpha/) and subject to change), which looks like this:

{{< gist atsvetkov 4b5e0efdc8612b7746e57f045d2dc37a >}}

{{< figure src="/images/visual-studio-project-file.png" title="" >}}

This is the moment when you say, *"Hold on, do I really see you editing the project file and having the project loaded at the same time?"*. Yes! Finally we don't need to unload the project when manually changing .csproj. This thing alone is a big time-saver, I'm really happy about it.

### C# 7.0 features

Now to the exercise. Let's imagine we need to implement an integer parser, so given a string input `"123"`, it will return an `int` with value `123`. We'll create it as a static `IntegerParser` class with `TryParse` method, with some additional requirements:

1. `TryParse` should accept an `object` and return a `bool` depending whether parsing was sucessful or not (a common pattern in many .NET classes)
2. if parsing succeeds, the resulting `int` will be assigned to an `out` argument
3. supported types are `string` and `int` (so `TryParse` will have to check the actual type), in other cases an exception will be thrown.

Obviously these are weird and artificial requirements, but hopefully they will allow us to find some places where the new syntax of C# 7.0 makes the code more concise and expressive.

Here's how a quick implementation could look like:

{{< gist atsvetkov f0e8f82a9590ceda0edc0b157f11b68d >}}

Running this produces the expected results:

```
Parsed System.Int32 123, got 123
Parsed System.String 2017, got 2017
Could not parse System.String -1
Could not parse System.String 1a2b3c
Error when parsing: IntegerParser only accepts strings ans integers, type 'System.Char' is not supported
```

Several things here leave to be desired:

* all those `if`'s for type checking look very verbose and desperately want to be converted to a `switch` statement, but unfortunately, `switch` only works with [integral types](https://msdn.microsoft.com/en-us/library/exx3b86w.aspx)
* private method `ParseString` is only used in one place (maybe we actually *want* it to be usable only in one place), so having a separate method declaration might seem an overkill (it's pretty normal for C# developers, but could look strange for JavaScript or other functional languages developer, where [functions are first-class citizen](https://en.wikipedia.org/wiki/First-class_function))
* all this logic in `Main` where we have to declare a variable for the `out` result, check the `bool` result, and only in case of success we are actually interested in this value; it would be nicer to just get a result back, potentially multiple values at once.

Let's see what C# 7.0 can offer to tackle these issues.

### Pattern matching

[Pattern matching](https://en.wikipedia.org/wiki/Pattern_matching) is common in functional languages like [F#](https://docs.microsoft.com/en-us/dotnet/articles/fsharp/language-reference/pattern-matching) or [Scala](http://docs.scala-lang.org/tutorials/tour/pattern-matching.html) or [Elixir](http://elixir-lang.org/getting-started/pattern-matching.html), but C# itself is now getting more functional too. C# 7.0 brings in support for *type pattern matching* in `if` and `switch` statements, meaning that we can now have much richer `switch` behaviour. This allows us to rewrite our `TryParse` method like this:

{{< gist atsvetkov b5a903fad4daf8874f407c5f9cdb2456 >}}

The code is a bit terser now and doesn't have ugly casts.

### Local functions

Yes, you guessed it - now functions can be defined inside a method. We could do something similar in C# 6.0 with *lambda expressions*, but they have some limitations compared to normal methods (no `out`, `ref`, `params` or optional parameters, cannot be generic). And obviously any `Func` instance would mean an extra memory allocation, creating unnecesary pressure on garbage collector.

With local functions we can rewrite our `TryParse` method even further, including `ParseString` in the body of the method:

{{< gist atsvetkov 82eef08eb8cd6bdb84e86344d94f096c >}}

Again, not that it makes a lot of sense to write it this way, but at least there is this option to declare small helper functions exactly where they are needed.

Note that this is not some kind of crazy magic, the compiler will actually convert this local function into a `private static` method, but from code perspective it will only be accessible in scope of the method it was defined in.

### Out variables

Having to pre-declare a variable for an `out` parameter has always seemed like a code smell to me. In case of the popular `TryXXX` pattern, obviously, I'm only interested in the *value* of the variable, if my `TryXXX` check returned `true`, so why bother defining it in outer scope? Luckily, in C# 7.0 this is fixed! Visual Studio 2017 RC even displays a quick action lightbulb to suggest inlining this variable:

{{< figure src="/images/visual-studio-out-variable.png" title="" >}}

This allows to remove the pre-declaration of the `out` variable, so that the compiler can declare it on-the-fly. Just one line less, but reads much better, I think:

{{< gist atsvetkov d2380a846b78cccd8fab1bf8ec1fcc6f >}}

This `result` variable is now *declared* and *assigned* as one statement, leaving the implementation details to the compiler.

### Tuple types and deconstruction

Now, all this tweaking of `out` variables and playing with `TryParse` syntax is only hiding the real problem: essentially we want our method to return *two* values at once: the success/failure flag and the result itself. Since C# methods don't support returning multiple results, there are two common solutions to this: `out`/`ref` parameters or a special result type. We could indeed define a type which would hold two values we need and then check it from the client code:

{{< gist atsvetkov 67372886923c30069ca7c3185346142a >}}

{{< gist atsvetkov ef7185260bea5025e24e20945dcca49e >}}

But if we only need this result type for this single method and never reuse it anywhere else, this type declaration feels a bit redundant. If a class is only used once, maybe it doesn't deserve to be explicitly declared. In fact, since .NET Framework 4.0 we have `Tuple` class to the rescue, but it is a bit cumbersome to use with these meaningless `Item1`, `Item2` etc. property names.

C# 7.0 makes tuples a first class citizen in syntax and compilation, so we can actually write methods which *look* like they return multiple values. Under the hood, again, the compiler will use tuples, but the code will read much better. Let's see how we can rewrite the `TryParse` one last time:

{{< gist atsvetkov c9353788acac9eab9f5851bda321272f >}}

(Note: for this to work you would need to install an additional [System.ValueTuple NuGet package](https://www.nuget.org/packages/System.ValueTuple/))

I think this code shows the *intent* of the function much better, it is immediately visible what the return type(s) will be.

The calling code can now be rewritten to assign the returned `bool` and `int` values to two variables in just one very readable line (this is called *deconstruction* or *destructuring*):

{{< gist atsvetkov 67a25415fe660c70498567c6261fc187 >}}

### New refactorings

You might have noticed that `IntegerParser` class is defined in the same file where `Program` lives. This is definitely not the best practice, so normally I would use ReSharper to apply *Move Type to Another File* refactoring. This kind of handy tricks have always been the reason I would stick to ReSharper, even though I never liked to be so dependent on a specific tool.

Well, now Visual Studio 2017 RC can do this too!

{{< figure src="/images/visual-studio-extract-to-file-refactoring.png" title="" >}}

[Read more](https://msdn.microsoft.com/magazine/mt790181) about refactorings and other productivity improvements.

### Summary

We went through a very artificial coding exercise, which hopefully showed how some of the new C# 7.0 features can make code a bit more readable and expressive. Besides language improvements, the new Visual Studio 2017 already looks like a great step towards better IDE performance and productivity. I am really looking forward to the final release in 2017!

The source code of this silly integer parsing solution is available at [https://github.com/atsvetkov/csharp-7-vs-2017-short-demo](https://github.com/atsvetkov/csharp-7-vs-2017-short-demo).

Thanks for reading and Merry Christmas!