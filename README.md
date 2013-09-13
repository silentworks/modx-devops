# modx-devops

Easily setup a local development environment for MODX using a [Vagrant][]. You'll be able to run MODX sites as well as have the new toolkit needed to contribute to the MODX Manager using the new [Manager Contribution Workflow][new toolkit].

The aim of this repository is to serve as an alternative to the [official setup][] which requires installing dependencies at the system level.

This setup bundles all dependencies into a Vagrant (VirtualBox) providing you with a Vagrant setup for MODX with Apache, PHP, MySQL and xdebug. This allows you to contribute to the Manager UI, which currently uses
Grunt build tool along with Sass and a few other third party libraries.

## Install Dependencies
Once you have these two setup, you can proceed to the next steps.

 * [Vagrant][]
 * [VirtualBox][]


## Setup
#### 1. Fetch Source
First, clone a copy of this git repo by running:

```bash
git clone git://github.com/silentworks/modx-devops.git
```

#### 2. Update Vagrantfile
Open this project in your favourite TextEditor/IDE, then edit the __Vagrantfile__, change repo to your fork of the 
MODX repository. __This step is necessary in order to send in Pull Requests.__

__Windows users only, OSX users skip to [step 3](#Create Vagrant Environment).__

We are making use of symlink in the project because of the way Grunt works, in order to get this to work on Windows
you will need to do some extra steps first.

You will need to open your cmd prompt in Administrator mode and run the following:

```bash
fsutil behavior set SymlinkEvaluation L2L:1 R2R:1 L2R:1 R2L:1
```

#### 3. Create Vagrant Environment
Simply spin up a vagrant instance:

```bash
cd modx-devops
vagrant up
```
_Note: `vagrant up` can take several minutes to initially complete._

You can now navigate to http://192.168.33.121/setup/ in your web browser.

#### 4. Use SSH

ssh into the box so you can use things like the [grunt workflow commands][grunt workflow].

```bash
vagrant ssh
cd /vagrant/www/_build/templates/default
```

Now lets get Bower dependencies:

```bash
grunt build
```

Now lets start watching the filesystem for changes

```bash
grunt
```

_Note: grunt is now watching files for changes. When Sass files are changed CSS will automatically be generated.<br>Install the LiveReload [browser extension](http://feedback.livereload.com/knowledgebase/articles/86242-how-do-i-install-and-use-the-browser-extensions-) to inject CSS changes without a page refresh._

And thats it, go on and edit your SASS files and watch grunt run each time you make a save.

## Credentials
#### Database Info

- username: vagrant
- password: vagrant
- database name: default


[Vagrant]: http://www.vagrantup.com/
[VirtualBox]: https://www.virtualbox.org/
[grunt workflow]: https://github.com/modxcms/revolution/blob/develop/_build/templates/default/README.md#grunt-commands
[new toolkit]: https://github.com/modxcms/revolution/tree/develop/_build/templates/default#contribution-guides
[official setup]: https://github.com/modxcms/revolution/tree/develop/_build/templates/default#what-you-need
