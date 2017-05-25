+++
date = "2017-05-21T15:14:22+02:00"
draft = true
title = "5 ways to manage database schema changes in dotnet"
displaytitle = "5 Ways To Manage Database Schema Changes in 2017 (in .NET)"
Categories = []
Tags = []
Description = ""

+++

### Problem

Most useful applications these days store some database in some storage. Sometimes this storage is a relational database with a well-defined schema. This schema might evolve with time, requiring production databases to be updated. In some cases, this is a rare occasion and perhaps can be done manually. However, if a company follows an agile approach and is trying to deliver new releases continuously, then these manual updates can quickly become too much of a headache even for experienced DBAs.

Luckily, this problem is not new at all, so there are tools to help with that. Most of my career I have been developing with .NET, so I will only discuss tools that make sense for .NET developers. Also, I'm not going to talk about commercial tools like [RedGate's SQL Compare](http://www.red-gate.com/products/sql-development/sql-toolbelt/) in this context - first, because there are excellent free open-source libraries for that, and second, because I just don't have enough experience with them (probably, because of the first reason).

To give you some context, my team and I are currently working on a bunch of .NET web applications, some legacy and some a bit newer. All of them communicate with MS SQL Server databases, and in some cases the schema goes about 7-8 years back... needless to say, it changes *a lot*. We release every 3 weeks and the whole release process is automated using [Octopus Deploy](https://octopus.com/) with some sprinkles of [Chocolatey](https://chocolatey.org/) on top. Database schema is managed using [database projects](https://msdn.microsoft.com/en-us/library/xee70aty.aspx), which does dynamic schema comparison at deployment time... and as much as this is convenient, it can sometimes lead to problems (more on this later). 

(*The road to automated release pipeline was not easy and deserves a separate blog post, which I will definitely write one day. There was so many lessons learned while making a legacy software platform continuously deliverable, that I just can't not share it.*)

So, since we are not exactly happy with using database projects anymore, I decided to evaulate other options, with all their benefits and drawbacks, especially with the migration from database projects in mind.

### 1. SQL Server Data Tools

Microsoft's [SQL Server Data Tools](https://msdn.microsoft.com/en-us/library/hh272686.aspx) is an excellent option for source-controlling a database schema using a database project in Visual Studio. The actual deployment can be done through the [sqlpackage.exe](https://msdn.microsoft.com/en-us/library/hh550080.aspx) command-line tool or programmatically by referencing a corresponding DLL. We have used both approaches in our team, with a coded one useful when creating a custom installer application and the CLI tool more suitable for Octopus-based deployments.

Real production databases will have very different sizes, and when a complex schema change is combined with millions of records in a table, it might take quite a while for the database project tooling to apply the diff scripts. Generally, it behaves like a magical blackbox and makes us developers be less careful when modifying the database schema. Let me give you an example. Since SQL Server data tools integrate nicely with Visual Studio, you can add/remove/rename columns to a table definition in a visual designer. What happened more than once is developers inserting a column *in the middle* of the table, because, for example, the column name suggests that specific position. And although this sounds like a harmless change, at deployment time it will result in database project tools copying the contents of the table to a temporary one, dropping/recreating it and then copying data to the new table. This can be very time-consuming.

{{< figure src="/images/database-project-column-in-the-middle.png" title="" >}}

Obviously, I'm not trying to blame a tool for human error, but in my experience visual designers in IDEs hide complexity too much and allow for more errors to be silently made.

At the end of the day, the schema and pre/post-deployment scripts are stored just nicely organized SQL scripts, so there is no DSL involved. This is actually an important point when you already have quite a lot of these scripts and want to consider migrating to an alternative tool (more on this in the last option on the list).

To apply the migrations from Visual Studio, you can right-click "Publish" on the database project, which will ask for a connection string and then do its magic. Automated deployment approach, obviously, will rely on either *sqlpackage.exe* or custom code using SSDT assemblies.

{{< figure src="/images/database-project-publish.png" title="" >}}

### 2. Entity Framework Migrations

If your project already relies on [Entity Framework](https://docs.microsoft.com/en-us/ef/), then going for [EF Migrations](https://msdn.microsoft.com/en-us/library/jj591621.aspx) is a natural step. Running *Enable-Migrations* in Package Manager Console will configure the project with migrations support, so after any modification to the project's DbContext you can run *Add-Migration*, which will detect the changes in the code and create a new migration file.

### 3. Fluent Migrator

### 4. ReadyRoll

### 5. DbUp

### Conclusion