+++
Categories = ["wix", "installer", ".net", "open source"]
Description = ""
Tags = ["wix", "installer", ".net", "open source"]
date = "2016-10-27T22:20:54+02:00"
title = "Some facts about WiX"
+++

Before we start, let me ask you a question: do you know what is the oldest still active open source .NET project?

Today I was again listening to awesome [.NET Rocks](https://www.dotnetrocks.com/) podcast and the guest was Rob Mensching, the guy behind [Wix Toolset](http://wixtoolset.org/). WiX provides a bunch of tools to simplify the creation of MSI packages for Windows, and as far as I know, it is one of the most popular open-source implementations in that area. And it is also free! We use it for the product I am currently working on. Hell, even Microsoft is using it: [see for yourself](https://github.com/dotnet/cli/blob/rel/1.0.0/packaging/windows/clisdk/dotnet.wxs) that the current .NET Core installer is actually built with WiX! In fact, Rob Mensching used to work in Microsoft on setup and deployment for Office, Windows and Visual Studio. Obviously, he knows more about installers than most people do, enough to build a business around it. So he is now a CEO and a co-founder of [Fire Giant](https://www.firegiant.com/), a company providing commercial support for WiX Toolset.

In a nutshell, WiX allows to define the package contents and installation steps in a declarative way, using XML files like this (taken from [WiX documentation](https://www.firegiant.com/wix/tutorial/getting-started/)):
```
<?xml version='1.0' encoding='windows-1252'?>
<Wix xmlns='http://schemas.microsoft.com/wix/2006/wi'>
    <Product Name='Foobar 1.0' Manufacturer='Acme Ltd.'
        Id='YOURGUID-86C7-4D14-AEC0-86416A69ABDE' 
        UpgradeCode='YOURGUID-7349-453F-94F6-BCB5110BA4FD'
        Language='1033' Codepage='1252' Version='1.0.0'>
    <Package Id='*' Keywords='Installer' Description="Acme's Foobar 1.0 Installer"
        Comments='Foobar is a registered trademark of Acme Ltd.' Manufacturer='Acme Ltd.'
        InstallerVersion='100' Languages='1033' Compressed='yes' SummaryCodepage='1252' />

...

<Directory Id='ProgramFilesFolder' Name='PFiles'>
    <Directory Id='Acme' Name='Acme'>
        <Directory Id='INSTALLDIR' Name='Foobar 1.0'>

...

<Component Id='HelperLibrary' Guid='YOURGUID-6BE3-460D-A14F-75658D16550B'>
    <File Id='HelperDLL' Name='Helper.dll' DiskId='1' Source='Helper.dll' KeyPath='yes' />
</Component>
```

Of course, it can do much more than just that, but I'm not going into too much detail. Instead I encourage you to [check out the podcast](https://www.dotnetrocks.com/?show=1367) and learn something new about installers business in general and WiX in particular. I learned a couple of things I didn't know before. First, there is a version 4 of WiX in development, which is a rewrite, so it should be better in all ways ([source code is available on GitHub](https://github.com/wixtoolset/wix4)). And second...

...and the second new thing actually brings us to the question I asked in the beginning. Turns out that nobody really knows what *the* oldest .NET open source project is, but WiX comes pretty damn close: it started in 1999 and was publicly released for the first time in 2004. So by any measure it is more than ten years old now! Two other pretty old and well-known ones are [NUnit](http://www.nunit.org/) in 2002 (a unit testing framework) and [Mono](http://www.mono-project.com/) in 2000-2001 (cross platform .NET framework that allowed to run C# and VB code on Linux long before [.NET Core](https://www.microsoft.com/net/core) came into being). Some discussions about those old open source projects took place in [this Rob's tweet](https://twitter.com/robmen/status/692843420981661696).

I personally think this is exciting: although Microsoft has only recently started to move towards open-source community, the community itself has been around for more than a decade now and has built tons of great tools and products.