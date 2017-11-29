+++
Tags = []
Description = ""
date = "2017-11-23T15:01:49+01:00"
title = "SDD Workshop: IdentityServer"
Categories = []

+++

A couple of weeks ago I finally got to learn [IdentityServer](https://identityserver.io/) from its creator, [Dominick Baier](https://leastprivilege.com/). A three-day workshop in London, as part of [SDD Deep Dive](https://sddconf.com/deep_dive_2017_workshops/), was indeed a *deep* dive into identity and access control in ASP.NET Core applications. It was a nice mix of presentations, live-coding, hands-on labs, and lots of cautionary tales based on Dominick's experience. Looking at the [current training schedule](https://identityserver.io/training/index.html), this 3-day version was a really unique chance to learn a lot and without a rush.

### Day 1

The first day was all about the new security model in ASP.NET Core 2.0. It is essential to understand how the basic authentication/authorization flow works, what is happening under the hood, and what can be configured. We learned about [`IAuthenticationService`](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.iauthenticationservice?view=aspnetcore-2.0) and its role in handling the requests, about hooking up multiple authentication handlers, about `Challenge`/`Forbid`/`SignIn`/`SignOut` verbs and what they are actually used for. Authorization was also covered, which wasn't that new for me, having done [Barry Dorrans' workshop](https://github.com/blowdart/AspNetAuthorizationWorkshop) a couple of months ago. A lot of these features rely on [Data Protection API](https://docs.microsoft.com/en-us/aspnet/core/security/data-protection/introduction), which is what makes encrypting cookies and signing tokens secure and provides an easy-to-use cryptography API to ensure *authenticity*, *confidentiality*, and *isolation*.

It was really fun to see Dominick explain us the internals of Microsoft's ASP.NET Core with all its quirks and sometimes almost inexplicable design decisions. More than once we looked into the actual source code of [https://github.com/aspnet/Security](https://github.com/aspnet/Security) repository to understand what was going on. I *love* this total openness of the new .NET world.

### Day 2

After understanding the security internals of ASP.NET Core, we naturally moved to the discussion of modern centralized authentication systems. At the core of it is [OpenID Connect](http://openid.net/), which is an identity/authentication layer on top of [OAuth 2.0](https://oauth.net/2/). The terminology in computer security is well-defined, but often abused and misunderstood, so Dominick stressed multiple times that OpenID Connect is really an *authentication* protocol (that is, a way of establishing user identity and confirming their claims), while the purpose of OAuth 2.0 is *access control*/*authorization*. Many companies, like Facebook or Twitter, have eventually built their own implementations of authentication protocols based on OAuth, and despite being based on the same underlying specification, these protocols are usually not compatible. That explains why every implementation of "sign-in with XXX" in ASP.NET Core lives in a separate NuGet package ([try searching nuget.org for Microsoft.AspNetCore.Authentication.*](https://www.nuget.org/packages?q=Microsoft.AspNetCore.Authentication.*)):

{{< figure src="/images/nuget_search_aspnetcore_authentication.jpg" title="" >}}

We discussed and implemented several *flows* of OpenID Connect, this time using IdentityServer4. All flows in the end should result in obtaining an *identity token* and validating it by the application. Dominick thoroughly explained the structure of the token and suggested to think about it not just as a list of user claims, but rather as an *authentication response*: custom claims are completely optional, but *protocol claims* (like *issuer*, *subject*, and *nonce*) are crucial for token validation and therefore are the most important content of the token.

Later during the day we moved forward to implementing external authentication and single sign-on, and this is where things got complicated. Turns out, signing users *in* into multiple applications is much easier than robustly signing them *out*. There are three official specifications for the sign-out process:

* [*front-channel notification*](http://openid.net/specs/openid-connect-frontchannel-1_0.html), targeting server-side web frameworks, where a single logout page will render an `<iframe>` for each registered app in order to make a call to every sign-out endpoint
* [*back-channel notification*](https://openid.net/specs/openid-connect-backchannel-1_0.html), which is also for server-side apps, but doesn't use the browser for performing sign-out and does it through the more secure *back channel* (obviously, requires the Security Token Service and the client apps to be in the same network to be able to communicate directly)
* [*JavaScript-based notification*](https://openid.net/specs/openid-connect-session-1_0.html), which targets single-page JS applications, is based on an `<iframe>` again and is the most robust one, since the `<iframe>` loaded from Identity Provider's URL will be able to access its cookie in the browser

Finally, we learned about using a *federation* pattern, where IdentityServer can be configured to trust multiple external authentication providers, but serve as a single identity provider for client apps. This approach has benefits of hiding the complexity of other providers behing the gateway, makes the implementation extensible, and in some cases also allows to save money (e.g. when using [Azure Active Directory](https://azure.microsoft.com/en-us/services/active-directory/), the costs are based on the number of users and client applications, and in the case of using IdentityServer as a federation gateway, this means **just 1 application**, which is neat).

### Day 3

Last day was dedicated to two main topics: access control for web APIs and authentication in JavaScript applications. We were reminded again that **OAuth 2.0 is not an authentication protocol**, but an *authorization framework* which allows client apps to securely obtain access to HTTP resources by means of tokens issued by Security Token Service. The labs included implementing *client credentials* flow for securing service-to-service communication (requires configuring a *shared secret* between the app and the Identity Provider) and *hybrid flow* for user-centric apps, as well as various scenarios of refreshing and revoking access tokens.

Going back to OpenID Connect, single-page JS apps can use the *implicit* flow to sign-in and obtain an access token. By the way, I finally learned why it's called "implicit": the token is passed to the app by making a call to a pre-registered callback URL, so the fact that the app is able to respond to a call to this URL *implicitly* confirms that this is indeed the trusted app (unlike the client credentials flow, where a shared secret is *explicitly* used as part of the validation process). Since the topic was related to web security in general, Dominick also explained some of the typical vulnerabilities and counter-measures, like anti-forgery cookies, XSRF tokens, and CORS headers.

We also briefly covered the authentication scenarios for native/mobile apps, which usually involves some paltform-specific tricks. That's not really my cup of tea, though, working mostly with web applications.

At the very end we learned a bit about the internals of Identity Server itself, its request pipeline and various extension points. It has a very nicely written and composed code base, with a clear architecture and thought-through "secure-by-default" settings (like, require HTTPS by default, forbid browser apps to request access tokens by default, no CORS allowed by default, etc.), which feels very important given that IdentityServer is a flexible *framework*, so you can start with minimal configuration and still expect the best security practices out of the box.

### Conclusion

Personally, I enjoyed the workshop a lot. Not only Dominick is an expert in the field, but he also explains everything very clearly and, with his backround in penetration testing and computer security consultancy, has a lot of real-world examples and stories to share. It was also a very relevant content for me, since I'm currently working on architecting a single-sign on solution for multiple web apps.

### Bonus

Just a minor cool C# thing I noticed in the IdentityServer code. Configuring it involves setting a lot of options for clients, scopes, and users; some of these options need to contain multiple values. 
Normally, when I design an "options" class (i.e. a *property bag*, no behaviour) to have a property which contains multiple values, I try to pick a collection-like type with the minimal performance impact. So, if I had a `Client` class with `AllowedScopes` property, and I only needed to initialize it once (since this is just an "options" container), I'd write something like this:

```
class Client
{
    public string[] AllowedScopes { get; set; }
}
```

And then, when it's being initialized:

```
var client = new Client
{
    AllowedScopes = new [] { "scope1", "scope2" }
};
```

Nice and clean, and since the property isn't going to change dynamically, I don't really need `List<string>` or something like that, and obviously a simple array is a bit more lightweight memory-wise.

But, I guess, giving hundreds of workshops and demos with IdentityServer takes its toll, so Dominick and Brock got really tired of typing `new []` all the time (*at least, that's my theory*). And C# has had [collection initializers](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/object-and-collection-initializers) for a long time already. Also, only distinct scopes make sense in this example, so I'd still need to use a property with a backing field and implement a duplicate check logic in the setter... which sounds very much like a job for [HashSet<T>](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.hashset-1?view=netframework-4.7.1). The trick (and actually the best practice) is to still expose the property via the minimal interface that hides the specific data structure implementation details and still allows to use collection initializers.

Ok, I talked enough, here's the updated `Client` class:

```
class Client
{
    public ICollection<string> AllowedScopes { get; set; } = new HashSet<string>();
}
```

Now we can write this sweet and simple, almost *JavaScriptey* code:

```
var client = new Client
{
    AllowedScopes = { "scope1", "scope2" }
};
```

And this is indeed [how the properties in the `Client` class are implemented](https://github.com/IdentityServer/IdentityServer4/blob/dev/src/IdentityServer4/Models/Client.cs#L147).

If you have to type such demo code like fifty times a week, you'll probably appreciate such a neat design.