+++
Categories = []
Description = ""
Tags = []
date = "2017-06-10T13:11:12+02:00"
title = "null checking allocations and mass refactoring with resharper"
displaytitle = "Null checking, allocations and mass refactoring with ReSharper"
+++

### Introduction

Imagine any .NET codebase you have worked on. What would be the most common usage of `if` statement in this code? Given the notion of [The Billion Dollar Mistake](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare), I bet it is the null check. Reference types in .NET are [allocated on the managed heap](https://docs.microsoft.com/en-us/dotnet/standard/automatic-memory-management), so when an instance of such a type is assigned to a variable, this variable essentially points to an adress in this managed heap. The default value of such a variable is `null`, meaning that it points to nothing and can't be dereferenced. For instance, if you write a method with a reference type argument, you can't always predict how this method is going to be invoked and there is no guarantee that it won't be a `null` value. To protect your code from an unexpected `NullReferenceException`, you would typically write something like this:

{{< gist atsvetkov 54a7a79366dc6d3aabb4ae97af8733f8 >}}

> *One could ask, "wait, aren't we just trading `NullReferenceException` for `ArgumentNullException` here?" That's true, if argument is null and is being used later, an exception will be thrown anyway, so we need to have some global exception handler in any case. But what makes a huge difference in debugging exceptions later is that we know which exception types we can expect. If all checks are done like this and you still see `NullReferenceException` in the log, then you know that something truly exceptional happened - and you can already eliminate a lot of possible reasons, since they would have resulted in exceptions of other specific types.*

This is a very popular approach of [defensive programming](https://en.wikipedia.org/wiki/Defensive_programming) and pretty soon such code is all over the place, making it less readable when there are many arguments to check. So, naturally the next step is to create some helper methods which encapsulate these checks. And now we are getting to the actual problem I am going to discuss.

### Null checking before C# 6.0

Checking for `null` is easy, but when throwing an `ArgumentNullException`, you will want to provide the name of the argument that was in fact `null`, in order to help a person debugging the code. So, the following code is just not enough:

{{< gist atsvetkov 343f3624d3c6d6bde2e2cd9875f5b97d >}}

{{< gist atsvetkov 4df132077018826dc5f459ffa318c803 >}}

Before C# 6.0, the only way to get this argument name without explicitly passing it from the calling code (can be done, but hardcoding strings is dangerous) was to accept a [lambda expression](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/statements-expressions-operators/lambda-expressions) instead of the value itself, so that the value can be obtained by compiling the expression into a delegate and then invoking this delegate, while the name of the argument could also be derived from the tree structure of the expression. Full code, if properly implemented, becomes quite involved and is not in scope of this post. But a rough pseudo-implementation of it might look like this:

{{< gist atsvetkov 4a5f4eeaad3396e81cdc2ead75bdc898 >}}

{{< gist atsvetkov 08be6f0bdb54670d81de5a2d975248d3 >}}

So, looks like we can figure out the original argument name this way and, of course, get the value itself too. Making the method generic allows us to set a constraint on the type of the value being checked: it just doesn't make sense to do null-checking of value types. If the magic part of turning an expression into a value is done right, this becomes a very flexible check, allowing to pass many different types of expressions, including plain values, properties, method calls etc. However, with this flexibility comes an overhead, which might not be obvious at first glance.

### Heap allocation ReSharper plugin

If you are optimizing some performance critical part of your code, I highly recommend installing either [Roslyn Clr Heap Allocation Analyzer](https://github.com/Microsoft/RoslynClrHeapAllocationAnalyzer) (requires Visual Studio 2015 though) or [Heap Allocations Viewer  ReSharper plugin](http://resharper-plugins.jetbrains.com/packages/ReSharper.HeapView.R2017.1/) (obviously, requires ReSharper). As a result, you will start seeing some interesting hints about performance:

{{< figure src="/images/resharper-allocation-hint.png" title="" >}}

What this means is that every time we call this method just to check if a value is null, .NET will allocate memory for an instance of an expression and for a closure that grabs the `input` argument value (let alone what happens inside the method itself). The codebase I am currently working with has been evolving for about 4 years (the project definitely started before C# 6.0), so this allocating version of `Guard.NotNull()` is used all over the place, including method calls and constructors.

> *Generally defensive programming means that you don't trust any caller of your code and try to take into account anything that can possibly go wrong. That, of course, includes null-checking of constructor arguments. However, if the team is using an IoC container to instantiate the types, one might argue that constructor checks are redundant: after all, most containers will throw anyway if it wasn't able to create an instance of a service that's being injected. There's no single "right" answer here and I would point an interested reader to [a related blog post by Mark Seeman](http://blog.ploeh.dk/2013/07/08/defensive-coding/), who is definitely a better expert in dependency injection are than I will ever be. As for the codebase I am talking about, the decision was made a long time ago to always check constructor arguments, so you can imagine that these null checks are just about everywhere.*

So, given that this code still evolves and we are already embracing version 7.0 of C#, how can we make this `Guard` class more memory-efficient?

### Null checking after C# 6.0

C# 6.0 introduced the [`nameof`](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/nameof) operator, which allows *"to obtain the simple (unqualified) string name of a variable, type, or member"*. With this, we can move the responsibility of providing the argument name to the caller, drastically simplify `NotNull` method and get rid of unnecessary allocations:

{{< gist atsvetkov 1406149461425280df5e81ae0e724ed7 >}}

{{< gist atsvetkov 73c12c85b51004298bf3ca32590284b3 >}}

Of course, you could say that passing the name this way could have been done from the very start, it would just have to be a hardcoded string (and ReSharper would even be smart enough to detect inconsistencies). But it is still not completely equivalent and, moreover, the expression-based approach is an evolutionary step in many other projects, so I guess it is not uncommon to eventually find yourself in such a situation.

### Mass refactoring using ReSharper

Alright, we have a better implementation now and we made a team agreement that all new code will use the non-allocating version. However, performance-wise we would still like to eliminate all existing usages of the allocating `NotNull` method. And this task, well, doesn't look very appealing:

{{< figure src="/images/resharper-notnull-usages.png" title="" >}}

What we want here is to perform a smart *semantically correct* find-and-replace, so that `() => value` expression gets converted into `value, nameof(value)`. Luckily, ReSharper supports creating [custom code inspections](https://www.jetbrains.com/help/resharper/2017.1/Code_Inspection__Creating_Custom_Inspections_and_QuickFixes.html), which will use a Regex-like pattern to find usages and display suggested refactoring. A custom pattern can be defined by going to **Resharper > Options > Code Inspection > Custom Pattern** menu:

{{< figure src="/images/resharper-custom-code-inspection-edit.png" title="" >}}

And, voilà! We are now getting hints for every usage of this obsolete code and can refactor them as any other ReSharper suggestion:

{{< figure src="/images/resharper-custom-code-inspection-apply.gif" title="" >}}

And now finally we can apply this refactoring to *all* usages in the solution by clicking *Search now* on the **Custom Patterns** page:

{{< figure src="/images/resharper-custom-code-inspection-search-now.png" title="" >}}

### Conclusion

Even such a seemingly simple task as null checking can be implemented in multiple ways, some better than others. When the programming language and codebase evolve through several years, new patterns become attractive and it may be relatively hard to fix all usages in a semantically correct way. In such cases, ReSharper can be of great help, allowing to both detect suspicious places and define custom refactorings. I realize that some people just don't use ReSharper at all, and that this article would probably make expert Vim/Emacs users laugh... but I hope this post can still be useful for a reasonably large group of .NET developers out there.

Thank you for reading!

### Bonus

There's no point in performance optimization unless performance is measured before and after. I don't have data for the real application I am working on, but I tried to compare the performance of allocating and non-allocating versions of our `Guard.NotNull()` methods using a super cool [BenchmarkDotNet](https://github.com/dotnet/BenchmarkDotNet) library. The testing code looks like this:

{{< gist atsvetkov c72c696d4c7c3c034f1f30a304f95b40 >}}

And produces these results:

{{< figure src="/images/guards-benchmark-results.png" title="" >}}

Well, perhaps this test is far from ideal, the average execution time of the non-allocating method is zero (was it eliminated by JIT?). The allocating version is clearly slower and uses additional memory and created some pressure on GC, which was exactly the point of the whole discussion. When an argument is not null (and that is probably true in 90% of the time our application is running), these allocating checks are just wasting memory and CPU, so if this happens in almost every transient service class constructor or method call, it makes sense to apply such optimizations.