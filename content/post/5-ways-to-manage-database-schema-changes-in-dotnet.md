+++
date = "2017-05-21T15:14:22+02:00"
draft = true
title = "5 ways to manage database schema changes in dotnet"
displaytitle = "5 Ways To Manage Database Schema Changes in 2017 (in .NET)"
Categories = []
Tags = []
Description = ""

+++

### Introduction

Most useful applications these days store some data in some storage. Sometimes this storage is a relational database with a well-defined schema. This schema might evolve with time, requiring production databases to be updated. In some cases, this is a rare occasion and perhaps can be done manually. However, if a company follows an agile approach and is trying to deliver new releases continuously, then these manual updates can quickly become too much of a headache even for experienced DBAs.

Luckily, this problem is not new at all, so there are tools to help with that. Most of my career I have been developing with .NET, so I will only discuss tools that make sense for .NET developers. Also, I'm not going to talk about commercial tools like [RedGate's SQL Compare](http://www.red-gate.com/products/sql-development/sql-toolbelt/) in this context - first, because there are excellent free open-source alternatives, and second, because I just don't have enough experience with them (probably, because of the first reason).

To give you some context, my team and I are currently working on a bunch of .NET web applications, some legacy and some a bit newer. All of them communicate with MS SQL Server databases, and in some cases the schema goes about 7-8 years back... needless to say, it changes *a lot*. We release every 3 weeks and the whole release process is automated using [Octopus Deploy](https://octopus.com/) with some sprinkles of [Chocolatey](https://chocolatey.org/) on top. Database schema is managed using [database projects](https://msdn.microsoft.com/en-us/library/xee70aty.aspx), which does dynamic schema comparison at deployment time... and as much as this is convenient, it can sometimes lead to problems (more on this later).

So, since we are not exactly happy with using database projects anymore, I decided to evaulate other options, with all their benefits and drawbacks, especially with the migration from database projects in mind. To make it slightly more interesting than just listing my impressions, I have created a GitHub repository with a VS solution with five projects illustrating how the discussed tools can be used. All of these projects solve the same super-simple task: define a *Person* table with several columns, then increase the length of *FirstName* column (as a separate migration file, where applicable). Hopefully this demonstrates how a typical agile development scenario can be supported by each tool. Where possible, projects also contain *apply-migrations.bat* batch file, showing how applying database changes can be automated via command-line (being able to do this is a must for our and probably many other teams where tools like Octopus Deploy are the core of the delivery pipeline).

The accompanying code can be found at [https://github.com/atsvetkov/database-migrations-dotnet](https://github.com/atsvetkov/database-migrations-dotnet), and the solution looks like this:

{{< figure src="/images/database-project-solution.png" title="" >}}

Now, let's walk through the 5 tools one by one and see how they can be used.

### 1. SQL Server Data Tools

Microsoft's [SQL Server Data Tools](https://msdn.microsoft.com/en-us/library/hh272686.aspx) is an excellent option for source-controlling database schema using a database project in Visual Studio. The actual deployment can be done through the [sqlpackage.exe](https://msdn.microsoft.com/en-us/library/hh550080.aspx) command-line tool or programmatically by referencing a corresponding DLL. We have used both approaches in our team, with a coded one useful when creating a custom installer application and the CLI tool more suitable for Octopus-based deployments.

Real production databases will have very different sizes, and when a complex schema change is combined with millions of records in a table, it might take quite a while for the database project tooling to apply the diff scripts. Generally, it behaves like a magic blackbox and makes us developers less careful when modifying the database schema. Let me give you an example. Since SQL Server data tools integrate nicely with Visual Studio, you can add/remove/rename columns to a table definition in a visual designer. What happened more than once is developers inserting a column *in the middle* of the table, because, for example, the column name fits better in that specific position. And although this sounds like a harmless change, at deployment time it will result in database project tools copying the contents of the table to a temporary one, dropping/recreating it and then copying data to the new table. This can be very time-consuming.

{{< figure src="/images/database-project-column-in-the-middle.png" title="" >}}

Obviously, I'm not trying to blame a tool for human error, but in my experience visual designers in IDEs hide complexity too much and allow for more errors to be made without knowing.

At the end of the day, the schema and pre/post-deployment scripts are stored as nicely organized SQL scripts, so there is no special domain-specific language involved. This is actually an important point when you already have quite a lot of these scripts and want to consider migrating to an alternative tool (more on this in the last option on the list).

To apply the migrations from Visual Studio, you can right-click "Publish" on the database project, which will ask for a connection string and then do its magic. Automated deployment approach, obviously, will rely on either *sqlpackage.exe* or custom code using SSDT assemblies.

{{< figure src="/images/database-project-publish.png" title="" >}}

### 2. Entity Framework Migrations

If your project already relies on [Entity Framework](https://docs.microsoft.com/en-us/ef/), then going for [EF Migrations](https://msdn.microsoft.com/en-us/library/jj591621.aspx) is a natural step. Running *Enable-Migrations* in Package Manager Console will configure the project with migrations support, so after any modification to the project's DbContext you can run *Add-Migration*, which detects the changes in the code and creates a new migration file.

For automation purposes, Entity Framework NuGet package also includes *migrate.exe* utility, which allows applying migrations from a specified DLL to a database with a specified connection string. What I find a bit weird is that you cannot just run the tool from where you find it in the packages folder: it requires *EntityFreamework.dll* as a dependency, but resides in *tools* subfolder, while this required DLL is, of course, is in *lib*. So, in order to run this correctly, you first need to copy the tool to where you assembly with migrations *and* EntityFramework.dll are located. The sample batch file in the corresponding project does exactly that:

{{< gist atsvetkov c43fc4f78b853336efdef048b210ac94 >}}

Entity Framework is at version 6.1.3 now (6.2.0 is in beta), so it is all very stable and works well. But, of course, it works for projects that used EF from the start. In our case, we already have 100+ SQL scripts, and also we, well, don't really like Entity Framework itself. Sometimes having full control over good old SQL is very comforting.

### 3. Fluent Migrator

[Fluent Migrator](https://github.com/fluentmigrator/fluentmigrator) also provides a high-level abstraction on top of SQL, allowing to define migrations in code using very readable fluent syntax, like this:

{{< gist atsvetkov 3a5c9798e7254df41d548b58648c1640 >}}

Fluent syntax only supports a certain number of SQL statements, which will probably cover 90% of typical scenarios, and for the remaining 10% there is `Execute.Sql()` method for running any custom SQL statement. Of course, using the fluent syntax gives more benefits with this tool, allowing, for example, to automatically derive the "down" rollback script from the normal "up" one. This is exactly why the class in the code snippet above inherits from `AutoReversingMigration`: because the whole migration is strongly-typed, it is technically possible to reverse the expression and figure out the compensating script. However, rolling database migrations back is never just about schema, it is also about the potential data loss, so I would always be extra careful when trusting any tool to do this automatically.

FluentMigrator's NuGet package also contains *migrate.exe* command-line tool, which loads migrations from an assembly and applies them to a target database. Generally all SQL migration tools create separate tables where already applied migrations will be listed. This allows to quickly determine which scripts still need to be run, in contrast with SQL Server Data Tools, where the diff is determined at runtime by comparing the schema of the actual database to the one in *.dacpac* file.

Unlike with other tools in this list, I couldn't make FluentMigrator create the database on the fly, if there wasn't one. Perhaps, I'm just missing something obvious, but the documentation doesn't seem to mention this.

### 4. RoundhousE

This tool, as well as the next one, stores migrations just as plain SQL files (like SSDT) and applies them via a console utility called *rh.exe* (as usual, it is included in the NuGet package). [RoundhousE](https://github.com/chucknorris/roundhouse) is perhaps the most advanced, which immediately becomes obvious from not-so-clear documentation. Compared to DbUp or Entity Framework, just firing up the simplest example with RoundhousE took me significantly longer. In the end, though, it looks solid and relies heavily on conventions. For instance, if specific path to migration files is not provided, the tool will look for *up* folder in the current directory and then execute any SQL scripts from there. There is support for *one-time*, *any-time* (whenever a script changes), and *every-time* (always run) scripts, which is pretty flexible and based on filename conventions. Migration history is stored in 3 tables and not only includes the version and the names of the scripts, but also the full script texts and text hashes (this is, I guess, how change detection for *any-time* scripts works). This is a slightly bigger storage overhead than in other tools, but makes it very robust.

{{< figure src="/images/database-migrations-roundhouse-tables.png" title="" >}}

### 5. DbUp

To be honest, [DbUp](http://dbup.github.io/) is my favorite tool in the list, mainly because of a really quick setup and [great documentation](https://dbup.readthedocs.io/en/latest/). The migration files are created as plain SQL files in the project, but then the build action for them needs to be set to *Embedded Resource*, effectively making them part of the assembly. And because of this the project with DbUp migrations can actually be made a console application (which is a recommended approach), which will load these resources and execute the scripts. So, the code in `Program.cs` can look like this:

{{< gist atsvetkov 584ef610fae4de285111d89ba38e20da >}}

Migration history, as usually, is stored in a special table, but there is a catch (at least, it is something to keep in mind). The identifier of an already executed script is its fully-qualified path inside the assembly, including project, folder and namespace:

{{< figure src="/images/database-migrations-dbup-tables.png" title="" >}}

If these scripts get moved to a different location or renamed, they will be detected as new and rerun during the next database upgrade. Depending on whether these scripts are idempotent or not, this might or might not be a big problem and perhaps can be solved by a team agreement or overriding how the script name is generated, but still it is important to take this into account, since this is the default behavior. For instance, FluentMigrator relies on marking migration classes with `MigrationAttribute` accepting a number, so each migration can be safely renamed as long as the sequence number stays the same.

### Conclusion

As always in our industry, there is no silver bullet in database schema change management. Plenty of tools can be used to manage database migrations, but each will have its own philosophy and drawbacks. For our project, it seems unreasonable to go for EntityFramework or FluentMigrator, since they store migrations as code, not plain SQL files like those we already have. This leaves us with RoundhousE or DbUp, and as of now I tend to favor DbUp because of its simplicity, even knowing certain limitations. Extra cognitive load can render all other benefits useless, so whenever possible I try to use the simplest possible tool.

Obviously, no two projects are the same, so I hope this overview can help someone to make an educated decision in their specific situation. If you want to see the working code, go ahead and check out [the sample repo on GitHub](https://github.com/atsvetkov/database-migrations-dotnet).
