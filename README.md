# Vagrant setup for MODX

## Manager Contribution Workflow

This setup will provide you with a Vagrant setup for MODX with Apache, PHP, MySQL and xdebug. This allows you to contribute to the Manager UI, which currently uses
GruntJS build tool along with SASS and a few other third party libraries. The aim of this repository is to serve as an alternative to the [official setup](https://github.com/modxcms/revolution/tree/develop/_build/templates/default#what-you-need) which requires installing dependencies at the system level.

This repository was created to bundle all dependencies into a Vagrant (VirtualBox) setup.

Before we get started, you will require only 2 dependencies.

[Vagrant][] and [VirtualBox][]

Once you have these two setup, you can proceed to the next steps.

## Setup
#### Step 1
First, clone a copy of this git repo by running:

```bash
git clone git://github.com/silentworks/modx-devops.git
```

#### Step 2
Open this project in your favourite TextEditor/IDE, then edit the Vagrantfile, change repo to your fork of the 
MODX repository. This step is necessary in order to send in Pull Requests.


__Windows users only, OSX users skip to next step__

We are making use of symlink in the project because of the way how Grunt works, in order to get this to work on Windows
you will need to do some extra steps first.

You will need to open your cmd prompt in Administrator mode and run the following

```bash
fsutil behavior set SymlinkEvaluation L2L:1 R2R:1 L2R:1 R2L:1
```

#### Step 3
Now we do:

```bash
cd modx-devops
vagrant up
```

You can now navigate to http://192.168.33.121/setup/ in your web browser.

#### Step 4

ssh into the box and start using the grunt workflow.

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

And thats it, go on and edit your SASS files and watch grunt run each time you make a save.

## Credentials
#### Database Info

- username: vagrant
- password: vagrant
- database name: default

[Vagrant]: http://www.vagrantup.com/
[VirtualBox]: https://www.virtualbox.org/
