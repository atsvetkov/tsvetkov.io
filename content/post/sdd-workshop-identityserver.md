+++
draft = true
Tags = []
Description = ""
date = "2017-11-08T15:01:49+01:00"
title = "SDD Workshop: IdentityServer"
Categories = []

+++

Last week I finally got to learn [IdentityServer](https://identityserver.io/) from his creator, [Dominick Baier](https://leastprivilege.com/). A three-day workshop in London, as part of [SDD Deep Dive](https://sddconf.com/deep_dive_2017_workshops/), was a really *deep dive* into identity and access control in ASP.NET Core applications. It was a nice mix of presentations, live-coding, hands-on labs, and lots of cautionary tales from Dominick's experience. Looking at the [current training schedule](https://identityserver.io/training/index.html), this 3-day version was a really unique chance to learn a lot and without a rush.

### Day 1

The first day was all about the new security model in ASP.NET Core 2.0. It is essential to understand how the basic authentication/authorization flow works, what is happening under the hood, and what can be configured. We leared about [`IAuthenticationService`](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.iauthenticationservice?view=aspnetcore-2.0) and its role in handling the requests, about hooking up multiple authentication handlers, about `Challenge`/`Forbib`/`SignIn`/`SignOut` verbs and what they are actually used for. Authorization was also covered, which wasn't that new for me having done [Barry Dorrans' workshop](https://github.com/blowdart/AspNetAuthorizationWorkshop) a couple of months ago. A lot of these features rely on [Data Protection API](https://docs.microsoft.com/en-us/aspnet/core/security/data-protection/introduction), which is what makes encrypting cookies and signing tokens secure and provides an easy-to-use cryptography API to ensure *authenticity*, *confidentiality*, and *isolation*.

### Day 2

- motivation for OpenID Connect
- flows of OIDC
- basics of Identity Server
- external authentication
- patterns (federation, client credentials)

### Day 3

- securing web APIs (access tokens, refresh, delegating identity)
- flows for JavaScript (SPA) applications
- flows for native apps (desktop, mobile)
- extensibility points of IdentityServer