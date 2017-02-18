+++
Description = ""
draft = true
Categories = []
Tags = []
date = "2017-02-18T14:35:25+01:00"
title = "abusing dotnet core cli"
displaytitle = "Abusing .NET Core CLI"
+++

### "dotnet new" and friends

When developing with .NET Core, you have two different workflows to choose from: manage projects from Visual Studio or work from a command-line, using `dotnet` commands. For example, new projects can be created this way, and after the recent updates the project templates system became extensible, allowing to install additional templates or even create your own. For example, this is how the output of `dotnet new` looks like by default with the latest RC installed (.NET Core 1.0 SDK RC4, to be specific):
```
> dotnet new
Template Instantiation Commands for .NET Core CLI.

Usage: dotnet new [arguments] [options]

Arguments:
  template  The template to instantiate.

Options:
  -l|--list         List templates containing the specified name.
  -lang|--language  Specifies the language of the template to create
  -n|--name         The name for the output being created. If no name is specified, the name of the current directory is used.
  -o|--output       Location to place the generated output.
  -h|--help         Displays help for this command.
  -all|--show-all   Shows all templates


Templates                                 Short Name      Language      Tags
--------------------------------------------------------------------------------------
Console Application                       console         [C#], F#      Common/Console
Class library                             classlib        [C#], F#      Common/Library
Unit Test Project                         mstest          [C#], F#      Test/MSTest
xUnit Test Project                        xunit           [C#], F#      Test/xUnit
Empty ASP.NET Core Web Application        web             [C#]          Web/Empty
MVC ASP.NET Core Web Application          mvc             [C#], F#      Web/MVC
Web API ASP.NET Core Web Application      webapi          [C#]          Web/WebAPI
Solution File                             sln                           Solution

Examples:
    dotnet new mvc --auth None --framework netcoreapp1.0
    dotnet new classlib --framework netstandard1.4
    dotnet new --help
```

We can additionally install [JavaScriptServices](https://blogs.msdn.microsoft.com/webdev/2017/02/14/building-single-page-applications-on-asp-net-core-with-javascriptservices/) templates like this:
```
dotnet new --install Microsoft.AspNetCore.SpaTemplates::*
```

Now, when we execute `dotnet new` once again, the list has grown bigger and we can use these nicely preconfigured .NET Core + React/Angular/etc. projects:
```
Templates                                  Short Name      Language      Tags
---------------------------------------------------------------------------------------
Console Application                        console         [C#], F#      Common/Console
Class library                              classlib        [C#], F#      Common/Library
Unit Test Project                          mstest          [C#], F#      Test/MSTest
xUnit Test Project                         xunit           [C#], F#      Test/xUnit
Empty ASP.NET Core Web Application         web             [C#]          Web/Empty
MVC ASP.NET Core Web Application           mvc             [C#], F#      Web/MVC
MVC ASP.NET Core with Angular              angular         [C#]          Web/MVC/SPA
MVC ASP.NET Core with Aurelia              aurelia         [C#]          Web/MVC/SPA
MVC ASP.NET Core with Knockout.js          knockout        [C#]          Web/MVC/SPA
MVC ASP.NET Core with React.js             react           [C#]          Web/MVC/SPA
MVC ASP.NET Core with React.js and Redux   reactredux      [C#]          Web/MVC/SPA
Web API ASP.NET Core Web Application       webapi          [C#]          Web/WebAPI
Solution File                              sln                           Solution
```

These new SPA templates are built by [Steve Sanderson](http://blog.stevensanderson.com/) (the author of [knockout.js](http://knockoutjs.com/)) and deserve a separate post, so I'm not going to discuss them now. What I want to talk about instead is the extensibility of `dotnet` command.

### How "dotnet" command works

Obviously, there is not too much magic: the .NET Core installer copies `dotnet.exe` to *C:\Program Files\dotnet\dotnet.exe* and adds this directory to PATH. When in doubt, remember about `where` command, which can help identify the location of an executable:
```
> where dotnet
C:\Program Files\dotnet\dotnet.exe
```

In most cases `dotnet` command will be executed with an additonal argument, which is the actual action we want to perform, like `new`, `build`, or `run`. The list of supported ones can be displayed by running `dotnet help`:
```
Commands:
  new           Initialize .NET projects.
  restore       Restore dependencies specified in the .NET project.
  build         Builds a .NET project.
  publish       Publishes a .NET project for deployment (including the runtime).
  run           Compiles and immediately executes a .NET project.
  test          Runs unit tests using the test runner specified in the project.
  pack          Creates a NuGet package.
  migrate       Migrates a project.json based project to a msbuild based project.
  clean         Clean build output(s).
  sln           Modify solution (SLN) files.
```

All of them are the built-in commands, which can be seen [in the source code](https://github.com/dotnet/cli/blob/rel/1.0.0/src/dotnet/Program.cs):
```
public class Program
{
    private static Dictionary<string, Func<string[], int>> s_builtIns = new Dictionary<string, Func<string[], int>>
    {
        ["add"] = AddCommand.Run,
        ["build"] = BuildCommand.Run,
        ["clean"] = CleanCommand.Run,
        ["help"] = HelpCommand.Run,
        ["list"] = ListCommand.Run,
        ["migrate"] = MigrateCommand.Run,
        ["msbuild"] = MSBuildCommand.Run,
        ["new"] = NewCommandShim.Run,
        ["nuget"] = NuGetCommand.Run,
        ["pack"] = PackCommand.Run,
        ["publish"] = PublishCommand.Run,
        ["remove"] = RemoveCommand.Run,
        ["restore"] = RestoreCommand.Run,
        ["restore-projectjson"] = RestoreProjectJsonCommand.Run,
        ["run"] = RunCommand.Run,
        ["sln"] = SlnCommand.Run,
        ["test"] = TestCommand.Run,
        ["vstest"] = VSTestCommand.Run,
    };

...
```

However, if you tried using Entity Framework Core CLI, you know that it is managed using the [`dotnet ef`](https://docs.microsoft.com/en-us/ef/core/miscellaneous/cli/dotnet) command installed with a [separate NuGet package](https://www.nuget.org/packages/Microsoft.EntityFrameworkCore.Tools/1.1.0-preview4-final). And there is definitely no "ef" in the list of built-in commands above. How does this actually work? What happens when we execute `dotnet COMMANDNAME`?

The answer is again in the source code, same *Program.cs* file:
```
int exitCode;
Func<string[], int> builtIn;
if (s_builtIns.TryGetValue(command, out builtIn))
{
    exitCode = builtIn(appArgs.ToArray());
}
else
{
    CommandResult result = Command.Create(
            "dotnet-" + command,
            appArgs,
            FrameworkConstants.CommonFrameworks.NetStandardApp15)
        .Execute();
    exitCode = result.ExitCode;
}

return exitCode;
```

So *dotnet.exe* will try to find the `COMMANDNAME` in the predefined list, and if it isn't found, will try to run an executable with the filename `dotnet-COMMANDNAME`, passing down the rest of the original arguments to it. This only works if a file *dotnet-COMMANDNAME.exe* can be found in at least one of the places from the PATH variable.

In fact, this is *almost* true: it actually doesn't have to be an *.exe file, as you can see in the snippet above. Anything that is on PATH, can be executed and has the name `dotnet-COMMANDNAME` will do. Which opens some creative possibilities...

### Batch file

Let's start from the simplest example. I created a batch file *dotnet-hi.bat* in *C:\tools\go\bin* which happens to be in my computer's PATH, with the following content:
```
@echo off
echo Hi there!
```

And now I can do `dotnet hi`:
```
> dotnet hi
Hi there!
```

Ok, it works, but not soo exciting. Let's have some more interaction and create the following `dotnet-flickr.bat` file:
```
@echo off
set "url=https://www.flickr.com/photos/tags/%1"
start %url%
```

Now, when you are feeling sad, just run `dotnet flickr cats` and be happy!

{{< figure src="/images/dotnet-flickr-cats.png" title="" >}}

We can also do something at least remotely useful, for example, create a `dotnet-code.bat`, which will start Visual Studio Code in the current directory:
```
@echo off
code .
```

{{< figure src="/images/dotnet-code.png" title="" >}}

### dotnet rocks!

You can only do much with scripting, so there will be a point when a full-blown executable will make more sense. Plus, so far the commands have been still pretty simple and boring. And since I am a big fan of [.NET Rocks! show](https://www.dotnetrocks.com/), I decided to pay a tribute to Carl and Richard: the greatest podcast about .NET deserves its own `dotnet` command.

So let me introduce you to `dotnet rocks`!

