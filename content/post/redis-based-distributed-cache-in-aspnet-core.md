+++
date = "2017-08-13T01:00:00+02:00"
title = "Redis-based distributed cache in ASP.NET Core"
displaytitle = "Redis-based distributed cache in ASP.NET Core"
Categories = []
Tags = []

+++

### Introduction

One of the things I particularly like about the new ASP.NET Core is that it's been designed as a framework with very sensible defaults. The flexibility of rewiring everything the way you like is still there, but the defaults cover what the majority of developers will probably need in most typical scenarios. Also, the definition of the "typical scenario" has significantly changed since the early days of ASP.NET. For instance, caching has always played an important role in web development, but the *way* we normally cache things today is different than it was 10 years ago.

[Dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) and [distributed caching](https://en.wikipedia.org/wiki/Distributed_cache) have become so mainstream these days, that ASP.NET Core has built-in support for both. When would you want to use a distributed cache? Mostly when scalability starts to matter. In-process cache is obviously faster than any distributed solution, so it is the right approach as long as there is just one instance of the application running. However, when scaling horizontally, more instances will start caching the same kind of data, which means caching will be less memory-efficient and it will be harder to invalidate all caches at once. Also, if such cache is used for storing user sessions, the load balancer will need to send subsequent user requests to the same instance, effecively requiring you to implement [sticky sessions](https://stackoverflow.com/questions/10494431/sticky-and-non-sticky-sessions), which are generally considered bad for scaling. (For obvious reasons: instead of evenly distributing requests across multiple servers, the load balancer now has to group them based on the user data, which leads to potentially suboptimal load distribution.)

There are many implementations of distributed cache systems, including [Redis](https://redis.io/), [Memcached](https://memcached.org/), [NCache](http://www.alachisoft.com/ncache/), and many others. Of those, Redis gained so much traction that [it is available as a standard caching solution in Microsoft Azure](https://azure.microsoft.com/en-us/services/cache/). So, it's no surprise that one of the default implementations of a distributed cache in ASP.NET Core also uses Redis.

In this post I want to give a very brief example of what it takes to start using distributed cache in .NET Core 2.0.

### Distributed cache API

From developer's perspective, all caching-related functionality in ASP.NET Core is available in [`Microsoft.Extensions.Caching.*` NuGet packages](https://www.nuget.org/packages?q=Microsoft.Extensions.Caching), including:

* [`Microsoft.Extensions.Caching.Abstractions`](https://www.nuget.org/packages/Microsoft.Extensions.Caching.Abstractions/) - common types and interfaces
* [`Microsoft.Extensions.Caching.Memory`](https://www.nuget.org/packages/Microsoft.Extensions.Caching.Memory/) - in-memory version of cache
* [`Microsoft.Extensions.Caching.Redis`](https://www.nuget.org/packages/Microsoft.Extensions.Caching.Redis/) - Redis-based implementation
* [`Microsoft.Extensions.Caching.SqlServer`](https://www.nuget.org/packages/Microsoft.Extensions.Caching.SqlServer/) - SQL Server-based implementation

 The built-in API support of distributed cache is represented by [`IDistributedCache`](https://github.com/aspnet/Caching/blob/dev/src/Microsoft.Extensions.Caching.Abstractions/IDistributedCache.cs) interface, which looks like this:
```
public interface IDistributedCache
{
    byte[] Get(string key);
    Task<byte[]> GetAsync(string key, CancellationToken token = default(CancellationToken));
    void Set(string key, byte[] value, DistributedCacheEntryOptions options);
    Task SetAsync(string key, byte[] value, DistributedCacheEntryOptions options, CancellationToken token = default(CancellationToken));
    void Refresh(string key);
    Task RefreshAsync(string key, CancellationToken token = default(CancellationToken));
    void Remove(string key);
    Task RemoveAsync(string key, CancellationToken token = default(CancellationToken));
}
```

If both Redis and SQL Server are not an option, there are many community-driven implementations based on other key-value stores - for instance, [Couchbase.Extensions.Caching](https://www.nuget.org/packages/Couchbase.Extensions.Caching) for [Couchbase](https://www.couchbase.com/) or [EnyimMemcached](https://www.nuget.org/packages/EnyimMemcached/) for [Memcached](http://memcached.org/).

### Configuring Redis and enabling distributed caching

As an example, I wanted to try out the built-in Redis implementation, so here are the steps to enable this in a ASP.NET Core 2.0 application.

1. Make sure you have Redis running. I'm doing all this on Windows, so have to use [Microsoft's port](https://github.com/MicrosoftArchive/redis). It is available as a [Chocolatey package](https://chocolatey.org/packages/redis-64), so the easiest way to install it is by running `choco install redis-64`. After that you should be able to start Redis server from the console and see something like this:

    ```
    $ redis-server
    [28504] 12 Aug 20:00:15.415 # Warning: no config file specified, using the default config. In order to specify a config file use C:\ProgramData\chocolatey\lib\redis-64\redis-server.exe /path/to/redis.conf
                    _._
            _.-``__ ''-._
        _.-``    `.  `_.  ''-._           Redis 3.0.503 (00000000/0) 64 bit
    .-`` .-```.  ```\/    _.,_ ''-._
    (    '      ,       .-`  | `,    )     Running in standalone mode
    |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
    |    `-._   `._    /     _.-'    |     PID: 28504
    `-._    `-._  `-./  _.-'    _.-'
    |`-._`-._    `-.__.-'    _.-'_.-'|
    |    `-._`-._        _.-'_.-'    |           http://redis.io
    `-._    `-._`-.__.-'_.-'    _.-'
    |`-._`-._    `-.__.-'    _.-'_.-'|
    |    `-._`-._        _.-'_.-'    |
    `-._    `-._`-.__.-'_.-'    _.-'
        `-._    `-.__.-'    _.-'
            `-._        _.-'
                `-.__.-'

    [28504] 12 Aug 20:00:15.418 # Server started, Redis version 3.0.503
    [28504] 12 Aug 20:00:15.418 * The server is now ready to accept connections on port 6379
    ```

    Verify that server is listening by starting Redis CLI and pinging the instance:

    ```
    127.0.0.1:6379> ping
    PONG
    ```

    I am by no means an expert in Redis, so if you want to know more about what, how and why, head over to the [official documentation](https://redis.io/documentation).

2. Assuming that you already have a .NET Core 2.0 web application code open (if not, first [download and install .NET Core 2.0 Preview 2 SDK](https://www.microsoft.com/net/core/preview#windowscmd) and create a new web app with `dotnet new web` command), you should already have everything prepared for enabling distributed caching. But, didn't I say that there is a specific NuGet package needed for this? Right, however the .NET Core 2.0 web app template references the uber meta-package [`Microsoft.AspNetCore.All`](https://www.nuget.org/packages/Microsoft.AspNetCore.All/), which already has this covered (this is a part of "sensible defaults" that I mentioned). You can easily see this if you download the package and look into the contents with [NuGet Package Explorer](https://github.com/NuGetPackageExplorer/NuGetPackageExplorer):

    {{< figure src="/images/microsoft-aspnetcore-all-package-contents.png" title="" >}}

    Right! No binaries inside (hence *meta*-package) and numerous dependencies. It is always possible to opt-out and manually add only the ones you actually want to use, but the default approach really makes it easier to start developing and avoid the versioning headache.

    In `Startup.cs` class, wire up Redis distributed caching in `ConfigureServices()` method:

    ```
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddDistributedRedisCache(options =>
        {
            options.Configuration = "localhost:6379";
        });
    }
    ```

3. Now we can consume the cache by injecting `IDistributedCache` instance wherever we need it:

    ```
    public class Foo
    {
        private readonly IDistributedCache _distributedCache;

        public Foo(IDistributedCache distributedCache)
        {
            _distributedCache = distributedCache;
        }
    }
    ```

    The interface methods work with byte arrays, so for a string to be stored it needs to be converted first:

    ```
    const string key = "message";
    const string message = "hello";

    var data = Encoding.UTF8.GetBytes(message);
    await _distributedCache.SetAsync(key, data);

    var cachedData = await _distributedCache.GetAsync(key);
    var cachedMessage = Encoding.UTF8.GetString(cachedData);
    ```

    However, caching strings is so common, that this logic is already wrapped into the extension methods in [`DistributedCacheExtensions`](https://github.com/aspnet/Caching/blob/dev/src/Microsoft.Extensions.Caching.Abstractions/DistributedCacheExtensions.cs) class from `Microsoft.Extensions.Caching.Abstractions` package. So, we can simplify the code a bit:

    ```
    const string key = "message";
    const string message = "hello";

    await _distributedCache.SetStringAsync(key, message);
    var cachedMessage = await _distributedCache.GetStringAsync(key);
    ```

### Important implementation detail

Apart from just using this just for conventional caching, Redis can help in implementing something like a [Command Query Reponsibility Segregation](https://docs.microsoft.com/en-us/azure/architecture/patterns/cqrs) pattern. Imagine we want to separate reads from writes to optimize performance. For instance, commands end up writing to SQL database, queries read from Redis cache, and a background process synchronizes the data in cache after writes happen (with messaging or based on a schedule - that really depends on the architecture requirements).

So, to simulate such background updates, I created a simple console app, referenced a popular [Redis client package from StackExchange](https://www.nuget.org/packages/StackExchange.Redis/) and made it periodically write a random Guid string to the same cache key:

```
static void Main(string[] args)
{
    var redis = StackExchange.Redis.ConnectionMultiplexer.Connect("localhost");
    var db = redis.GetDatabase();
    while (true)
    {
        db.StringSet("message", Encoding.UTF8.GetBytes(Guid.NewGuid().ToString()));
        Thread.Sleep(TimeSpan.FromSeconds(5));
    }
}
```

I honestly thought this would work, because purely from API perspective this code seems to write a string to the cache key and the web app code seems to read the same data. But that didn't work and it wasn't immediately obvious why. Due to asynchronously reading from the cache, the exception deep down was being swallowed and only showed up in Application Insights in Visual Studio when debugging (maybe there is better a way to catch this error?):

{{< figure src="/images/redis-exception-wrong-kind.png" title="" >}}

What? Why is the value of the wrong type? This is where abstractions start to leak, I think. Turns out that what Redis considers as *string* is not what ASP.NET Core implementation of `IDistributedCache` uses to store *.NET strings*.

If I open `redis-cli` again and check the type of the "message" item stored with `StackExchange.Redis` library, it is indeed a string (from Redis perspective):

```
127.0.0.1:6379> type message
string
```

Now let's save a string to Redis in ASP.NET Core's way:

```
await _distributedCache.SetStringAsync("message", "hello");
```

The type will be completely different this time:

```
127.0.0.1:6379> type message
hash
```

Luckily, the source code of [`RedisCache`](https://github.com/aspnet/Caching/blob/dev/src/Microsoft.Extensions.Caching.Redis/RedisCache.cs) type is available on GitHub, so we can indeed see that it uses [`HMSET`](https://redis.io/commands/hmset) Redis command, which saves the value in an instance of the hash type:

```
private const string SetScript = (@"
    redis.call('HMSET', KEYS[1], 'absexp', ARGV[1], 'sldexp', ARGV[2], 'data', ARGV[4])
    if ARGV[3] ~= '-1' then
        redis.call('EXPIRE', KEYS[1], ARGV[3])
    end
    return 1");
```

Ironically, this class even relies on the same `StackExchange.Redis` package... I'm pretty sure there are good reasons for storing string in hashes, but from developer's perspective this is absolutely not obvious and can be misleading. **Just by looking at the API's, it's hardly possible to guess that `StringSet()` method from one Redis library and `SetString()` from the other will internally store strings completely differently and in an incompatible way.**

### Conclusion

With ASP.NET Core it's never been easier to start using distributed caching. There is built-in support for Redis and SQL Server and of course there are already plenty of community effort to implement support for other key-value stores. Redis implementation is very easy to use; however, as much as `IDistributedCache` abstracts away the internals of Redis and tries to define a "common denominator" of all key-value stores, the implementation details might still leak and require developers to dig into how Redis actually works. Which I personally don't mind at all, but would still prefer to have more consistency in the API's.
