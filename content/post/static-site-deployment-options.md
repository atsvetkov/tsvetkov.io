+++
date = "2017-02-04T15:59:26+01:00"
title = "Static site deployment options"
Description = ""
Categories = []
Tags = []

+++

### Introduction

I know that for a lot of people their blog is something that should *just work*. So they go for WordPress and focus on writing, especially when a blog happens to be a major source of income. Well, mine has zero commercial value and I also enjoy being a web developer, so I keep using the blog as a guinea pig for new ideas.

When I first set everything up, the publishing pipeline looked like this:

1. a new post is pushed to the [github repo](https://github.com/atsvetkov/tsvetkov.io)
2. [Travis CI](https://travis-ci.org) is notified and triggers a build (luckily, this service is free for open-source projects, meaning - for everything that is public on github).
3. The build, well, builds the static site using [Hugo](https://gohugo.io/) CLI tool and then deploys it to a folder on a [DigitalOcean](digitalocean.com) server (a simple Ubuntu instance) via SSH and using `git push` to a remote on this server.
4. [Caddy](https://caddyserver.com/), my favourite little web server, serves the new content.

It all worked well until it didn't. At some point Travis CI builds would not trigger for way too long, then they would fail because the latest version of Hugo didn't work with my site sources, then it just would succeed without actually copying files or giving an error. So I got fed up and decided to explore different options. Potentially I also want to stop using my own server altogether, since there are free solutions for static site hosting at GutHub, GitLab and many others.

Don't expect a finished story, it is an ongoing process of improving the way this blog is deployed.

### Automated deployment from my own machine

First, I just decided to stop depending on Travis CI. As much as I like the idea of *continuous integration as a service*, being on a free tier often means using shared infrastructure and therefore having a higher level of uncertainty as to when the builds are actually triggered. So step one for me was to be able to deploy the blog to DigitalOcean in one command from my machine.

Ok, that can be done in many ways, and I have chosen the following:

1. open an SSH session to a server at DigitalOcean
2. run a bash script remotely, which will clone my git repo (and a slightly customized blog theme), run `hugo` on the server and copy the compiled static site to the web server content folder.

So, a `deploy.bat` executes a `remote.sh` script in a git shell:
```
"C:\Program Files\Git\bin\sh.exe" remote.sh
```

This `remote.sh` script simply sends the contents of the actual `deploy.sh` script as an input to a `bash` shell opened in an SSH session (this may look crazy for Windows people like me, but seems to be a well-known pattern in the Linux world):
```
cat deploy.sh | ssh root@tsvetkov.io 'bash -'
```

Finally, `deploy.sh` script will clone the repo and do the rest (this is already being executed on the remote machine):
```
git clone https://github.com/atsvetkov/tsvetkov.io.git /var/www/tsvetkov.io/temp
mkdir /var/www/tsvetkov.io/temp/themes
git clone https://github.com/atsvetkov/hyde.git /var/www/tsvetkov.io/temp/themes/hyde
~/work/bin/hugo -s /var/www/tsvetkov.io/temp -d /var/www/tsvetkov.io/html
rm -rf /var/www/tsvetkov.io/temp
echo done!
```

Took me a Friday evening to configure, but now I can deploy the blog to the current hosting server with a single `deploy.bat`. But what if I want to migrate from a personal server to some completely free hosting? Let's see some alternatives.

### GitLab Pages

[GitLab Pages](https://docs.gitlab.com/ee/user/project/pages/index.html) supports hosting static sites built from a repository at GitLab. To achieve that, one would have to configure a [pipeline](https://docs.gitlab.com/ee/ci/pipelines.html), which defines the steps to run during the build (usually triggered by a commit). GitLab actually makes it very easy to start by having several starter projects for various static site engines. Obviously, I just forked the [Hugo website example](https://docs.gitlab.com/ee/ci/pipelines.html) and configured the build pipeline in a `.gitlab-ci.yml` file in my repo. GitLab pipelines infrastructure seems to run on Docker containers, so this file defines the base image and the build actions:
```
image: alpine:3.4

before_script:
  - apk update && apk add openssl
  - wget https://github.com/spf13/hugo/releases/download/v0.16/hugo_0.16_linux-64bit.tgz
  - echo "37ee91ab3469afbf7602a091d466dfa5  hugo_0.16_linux-64bit.tgz" | md5sum -c
  - tar xf hugo_0.16_linux-64bit.tgz && cp ./hugo /usr/bin
  - hugo version

pages:
  script:
  - hugo
  artifacts:
    paths:
    - public
  only:
  - master
```

Basically, you can read this as "using `alpine` image, install OpenSSL and Hugo to my container and then build the site into `public` folder". Easy-peasy, and will result in an updated site at https://PROJECT_NAME.gitlab.io. Custom domains are supported too, so right now this version of my blog is running at https://alexandertsvetkov.me:

{{< figure src="/images/gitlab_pages_blog.png" title="" >}}

### GitHub pages

OK, this is all well and good, but the sources of my blog are actually stored on GitHub and keeping the version at GitLab in sync with the original one is not something I really want to be doing. Maybe I can actually use [GitHub Pages](https://pages.github.com/) directly?

Of course, I can! One of the way it is supported at GitHub Pages is the following:

1. A repository should have a special branch named `gh-pages`
2. When project is configured to use Pages and something is pushed to this branch, it will treat the files as a root folder of the site and serve them under some project-specific URL (once again, custom domain domains and HTTPS are supported)

A `deploy-to-gh-pages.bat` script to the rescue:
```
hugo --config config.gh-pages.toml
git add public
git commit -m "updated published static site"
git push
git subtree push --prefix public origin gh-pages
```

In this case Hugo will compile the site using a separate config file, since the base URL of the site has to be different (just until a domain name is remapped). Then the compiled static site is pushed from `public` subfolder to the `gh-pages` branch - and it automagically appears on the web under https://USER_NAME.github.io/REPO_NAME!

{{< figure src="/images/github_pages_blog.png" title="" >}}

### gh-pages npm tool

Turns out this is a very common scenario, so there are tools to do all of this special branching stuff automatically. Specifically, [`gh-pages`](https://www.npmjs.com/package/gh-pages) CLI tool is available in NPM repository, allowing to push to `gh-pages` branch from a git repo folder. After installing it with `npm install gh-pages --save-dev` (and doing `npm init` before that, since my blog wasn't originally configured to work with Node), I was able to deploy the site to GitHub pages with a single `gh-pages -d public` node command.

And to make it truly *npm-style*, we can configure a task in `package.json` like this:
```
"scripts": {
    "deploy": "gh-pages -d public"
  }
```

Which now allows to deploy from command line with `npm run deploy`.

### Even cooler tools

From all of the above you can see that I really like to do the deployment from command line (like all other tasks, in fact). And I am definitely not alone in that, since there are plenty of services with CLI tools for the same one-command deployments to their hosting. They seem to target exactly this kind of software developers, who prefer command line to mouse clicking, and provide a super simple convention-based experience instead.

One of them, [Surge](https://surge.sh/), can be installed with just `npm install --global surge`, and then you can literally deploy with one `surge` command from a project folder. It will upload the files and expose the site under a generated URL:

{{< figure src="/images/surge_blog_cli.png" title="" >}}

{{< figure src="/images/surge_blog.png" title="" >}}

(Obviously, I need to look into why my tiny blog is 19 MB in size, but that is a story for another time.)

Other interesting tool/hosting combinations include [now](https://zeit.co/now) and [staticland](https://static.land/), while [Netlify](https://www.netlify.com) is more like a replacement for GitHub Pages, providing CI on top of your repository, hosting and even CDN.

### Conclusion

It is absolutely a golden era of tech blogging. There is a huge choice of tools for authoring, deploying and hosting. Some are very developer-oriented, making them very attractive and easy to use.

Stay tuned to see where this blog ends up being hosted! And now I'm just going to run `deploy.bat` and relax.