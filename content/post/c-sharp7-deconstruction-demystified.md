+++
date = "2017-04-02T13:22:56+02:00"
title = "c sharp7 deconstruction demystified"
displaytitle = "C# 7.0: Deconstruction demystified"
Categories = []
Tags = []
Description = ""

+++

### Introduction

Let's talk about one of the cool new features of C# 7.0 - *deconstruction*. Quite often you might need to return more than one value from a method, which can be accomplished in several ways:

* use [`out`](https://msdn.microsoft.com/en-us/library/t3c3bfhx.aspx)/[`ref`](https://msdn.microsoft.com/en-us/library/14akc2c7.aspx) arguments (usually considered a code smell)
* create a more meaningful class/struct that represents the result of calling the method (a preferable option, especially as the number of returned values grows)
* use [`System.Tuple`](https://msdn.microsoft.com/en-us/library/system.tuple.aspx) (some kind of a middleground)

They all work, but in fact only a special return type feels like a good solution, since both `out` arguments and explicitly used tuples look just like a boilerplate code and don't contribute to readable code.

### Before C# 7.0

As an example, I'll use a very simple `GetPositiveNumber` method, which generates a random integer in the [-3, 3] interval and returns both the number and a boolean flag, specifying whether the nuber was actually positive. In previous versions of C#, if we followed the common `Try...` method pattern, it could look like this (imagine all of the following code to be inside a class):

{{< gist atsvetkov 838245cce67d0ba1ff730d9af7e37ee9 >}}

Rewritten with tuples, it would look not too different (but at least without `out` arguments):

{{< gist atsvetkov be95d55c39620833fc120466231704c4 >}}

Not too bad. It already shows the intent of the code much better: clearly, the method returns two things packed into a container type. But when we try to write the code that calls this method, it begins to look ugly:

{{< gist atsvetkov 5c65e720eae7a307c67d3ba278d4e11c >}}

These `Item1` and `Item2` properties don't really mean anything to the reader, they describe neither purpose, nor type. And this is exactly the problem that was solved with `ValueTuple` and deconstruction in C# 7.0.

### Deconstruction

What really felt wrong in the previous version of our code is that we could not give the tuple properties meaningful names and also we needed to first assign the tuple itself to a variable and only after that we could access the values. If you think about it, this is redundant: we are not interested in the tuple itself, we just want our values! So, C# 7.0 allows us to write the same functionality in a much shorter way:

{{< gist atsvetkov e065c97a041b524907873d4abb03bc07 >}}

**(IMPORTANT: for this to work, you need to manually install a *System.ValueTuple* NuGet package to your project, since the compiler will use types from it.)**

This way both values we are actually interested in are immediately assigned to the corresponding variables - *all in one line*! Also, the method signature now reads much better, since it is quite obvious that there are two return values.

After 12 years of .NET development, this looks like magic. And I don't like magic. So, if you are like me, the next thing you do is open your favourite IL disassembler (mine is [ILSpy](http://ilspy.net/)) and see what actually happens behind the scenes.

{{< figure src="/images/csharp7-deconstruction-ilspy-method.png" title="" >}}

So, essentially everything we wrote was just syntactic sugar, which then was turned into using a concrete `System.ValueTuple` struct. We can also see that the method is now marked with a [`TupleElementNames`](https://github.com/dotnet/corefx/blob/master/src/System.ValueTuple/src/System/Runtime/CompilerServices/TupleElementNamesAttribute.cs) attribute, which kept the names of the values returned by the original method. Obviously, we can deconstruct to local variables with any names, so this information is only preserved for displaying an Intellisense hint, when you hover over the method:

{{< figure src="/images/csharp7-deconstruction-ilspy-intellisense.png" title="" >}}

If we look at `ValueTuple<T1,T2>` itself, there is nothing really interesting, just a struct with (again!) `Item1` and `Item2` properties:

{{< figure src="/images/csharp7-deconstruction-ilspy-valuetuple.png" title="" >}}

So, how does this struct get assigned to two variables at once? Turns out, the compiler will use [duck-typing](https://en.wikipedia.org/wiki/Duck_typing) and check if there is `Deconstruct` method available on the type we are, well, deconstructing. Actually, the method doesn't have to be defined in the type itself, it can be declared as an extension method - which is exactly the case for `System.ValueTuple`:

{{< figure src="/images/csharp7-deconstruction-ilspy-tupleextensions.png" title="" >}}

Finally, the magic is revealed! The C# compiler will convert our nice and readable code into a bit more boring code using `ValueTuple`, and if there is a deconstruction statement used in the calling code, it will be rewritten with the `Deconstruct` method, if such exists.

This bring us to another interesting question: can we only use deconstruction with these value tuples or with custom types as well?

### Deconstructing custom types

Since we already saw that deconstruction works by using duck-typing, you can guess that the same trick works with our custom return types too. When might this be useful? Imagine you already have some method that returns a class, not a tuple, and you still want to leverage the deconstruction pattern when *calling* this existing method. Most likely you wouldn't want to rewrite the method to use tuples (too much work probably) - and luckily you don't have to! Just defining an extension method `Deconstruct` on the return type is enough to make compiler happy:

{{< gist atsvetkov db1583d6ecf4a67faa6c7ad1f1f1f5e3 >}}

This is, in my opinion, the best way to write this kind of code, since we managed to combine the best of both worlds: the method now returns a type with a meaningful name (and can easily be extended with more properties, if necessary), while, with the help of an extension method, we could deconstruct the result into two local variables - *still in one line*.

### Summary

One shouldn't underestimate such language improvements: even though there is, strictly speaking, no new functionality here, it greatly reduces the amount of boilerplate code and improves redability by making the intent of a method much clearer. After all, human time is the most expensive resource in software development, so having less lines of code to read (without sacrificing readability) is a big win.