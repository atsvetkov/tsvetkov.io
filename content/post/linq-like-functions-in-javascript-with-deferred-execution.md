+++
Categories = []
Description = ""
Tags = []
date = "2017-09-30T23:33:04+02:00"
title = "LINQ-like functions in JavaScript with deferred execution"

+++

Let's admit it: as C# developers, we are quite lucky. Not only the language is well-designed, but it also keep evolving and getting amazing new features. Moreover, Microsoft has changed the release strategy, so that we get both stable new versions and the "point releases". The current stable major release is C# 7.0, but you can already use [7.1](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-7-1) and [7.2](https://www.infoq.com/news/2017/06/CSharp-7.2) is coming soon. Also, everything is now happening in the open, so [here](https://github.com/dotnet/roslyn/blob/master/docs/Language%20Feature%20Status.md) we can see the C# language roadmap and feature status.

### LINQ in C\#

One of the features that probably makes programmers in other languages jealous is [Language Integrated Query](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/linq/). It allows to compose multiple filtering/aggregating/mapping steps when processing collections in a very readable and functional way. As an illustration, here's a piece of code that accepts an `IEnumerable<int>` and returns an array of only even numbers squared:
```
static class Foo
{
    public static int[] GetSquaredEvens(IEnumerable<int> numbers)
    {
        var query = from number in numbers
                    where number % 2 == 0
                    select number * number;

        return query.ToArray();
    }
}
```

Of course, these magic `from`, `where`, and `select` keywords are just syntactic sugar and will be turned by compiler into actual static methods calls of `System.Linq.Enumerable` type. So, the same code can be rewritten as a sequence of chained extension methods:
```
public static int[] GetSquaredEvens(IEnumerable<int> numbers)
{
    var query = numbers
                .Where(number => number % 2 == 0)
                .Select(number => number * number);

    return query.ToArray();
}
```

The reason I'm first creating a `query` variable and only then calling `ToArray()` method is to emphasize that **the filtering and squaring won't happen until the `IEnumerable<int>` is actually enumerated**. That is, by the time the `var query = ...` line has been executed, nothing happened yet, the LINQ logic was only *prepared* for execution.

I can imagine this is nothing new for the majority of C# developers out there, since we've had LINQ since 2007. What triggered me to write about this is a job interview I have recently had (on the interviewer side), where the candidate mentioned that he wrote an open source JavaScript library implementing some LINQ functions. It was written a while ago, when JavaScript didn't have [arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) yet. Some of the similar methods, like [Array.prototype.map()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map) and [Array.prototype.filter()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter), have been first implemented in [ECMAScript 5.1](http://www.ecma-international.org/ecma-262/5.1/) standard published in 2011. So, we can easily come up with a JavaScript function very similar to our C# version:
```
function getSquaredEvens(numbers) {
    var results = numbers
                .filter(number => number % 2 === 0)
                .map(number => number * number);
    
    return results; // no ToArray-like stuff, already enumerated
}
```

Looks very close to C# version, right? A big difference, however, is that `filter` and `map` functions are immediately executed, so the question I asked the interviewee (and myself) was about how we could implement such LINQ-like functions in JavaScript with *deferred execution* like in C#.

### Deffered execution in JavaScript?..

Luckily, JavaScript has been evolving too, so since [ECMAScript 2015](https://www.ecma-international.org/ecma-262/6.0) there is a concept of [generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Generator). It should, once again, seem very familiar to C# developers, since it is based on the `yield` keyword and allows to define function with custom iteration behaviour. Here is the simplest example from Mozilla documentation:
```
function* idMaker() {
    var index = 0;
    while(true)
        yield index++;
}
```

The asterisk denotes that this is not just a function, but a *generator*, which is a factory for *iterators*. Simply put, when executed, a generator function will return an iterator, which can be enumerated using [`for...of`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...of) loops.

That is exactly what we need! Now we can extend JavaScript's `Array` and `Generator` types with our own LINQ-like functions, so that they can be chained in any order and only get executed when iteration actually starts:
```
// define generator functions
const whereGenerator = function* (isMatch) {
    for (const item of this) {
        console.log('filtering!');
        if (isMatch(item)) {
            yield item;
        }
    }
};

const selectGenerator = function* (transform) {
    for (const item of this) {
        console.log('mapping!');
        yield transform(item);
    }
};

const toArrayFunction = function () {
    return Array.from(this);
};

// obtain generator prototype object
const Generator = Object.getPrototypeOf(function* () {});

// extend
Generator.prototype.where = whereGenerator
Array.prototype.where = whereGenerator

Generator.prototype.select = selectGenerator;
Array.prototype.select = selectGenerator;

Generator.prototype.toArray = toArrayFunction;
Array.prototype.toArray = toArrayFunction;
```

The code may look a bit funky, but the idea is simple: both `Array` and `Generator` types get extended with `where`/`select` generator functions (which, in turn, return generators too) and `toArray` function (this one terminates the chain, materializing the collection). This will allow us to chain these methods on both arrays and intermediate generators without actually enumerating. Only when `toArray` is called or results are iterated with `for...of` loop will generators start executing. To be able to easily check this, I have added `console.log()` statements to `where` and `select` generator functions (we'll use them shortly).

Finally, we can write our filtering/squaring LINQ-like function in almost the same manner as we did in C#:
```
const numbers = [1,2,3,4,5,6,7,8,9]

function getSquaredEvens(numbers) {
    const query = numbers
                .where(number => number % 2 === 0)
                .select(number => number * number);

    return query;
}

var results = getSquaredEvens(numbers);
debugger;

for (const number of results) { // results.toArray() will work too
    console.log(number);
}
```

If you try to execute it in the browser (I was testing this code in Chrome 61 and Firefox 56), the execution should pause at the line with `debugger` statement. Note that by this moment `getSquaredEvens` will have finished already, but since there's no `toArray` inside it, it only returns a chain of generators. To verify that no enumeration happened yet, you can switch to the *Console* tab and observe that nothing was written there:

{{< figure src="/images/generator-debugger-console-empty.png" title="" >}}

And if you continue the execution with F8, the `for` loop will start and you'll finally see messages being written in the console:

{{< figure src="/images/generator-debugger-console-messages.png" title="" >}}

Now we can do LINQ in JavaScript!

### More information

Obviously, this was just an exercise in understanding some advanced features of ES6, not anything resembling production-ready code. To efficiently work with collections in JavaScript, I would rather rely on mature libraries like [underscore](http://underscorejs.org/) or [lodash](https://lodash.com/). But if you, just like me, want to learn more about languages features of ES6, I would recommend something like a [ES6 couse by Wes Bos](https://es6.io/) or [ES6 Javascript: The Complete Developer's Guide by Stephen Grider](https://www.udemy.com/javascript-es6-tutorial/).