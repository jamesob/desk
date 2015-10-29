
# ◲  desk

[![build](https://api.travis-ci.org/jamesob/desk.svg)](https://travis-ci.org/jamesob/desk) [![Join the chat at https://gitter.im/jamesob/desk](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/jamesob/desk?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Lightweight workspace manager for the shell.

Desk makes it easy to flip back and forth between different project contexts in
your favorite shell. Change directory, activate a virtualenv or rvm, load
in domain-specific aliases, functions, arbitrary shell files, all in a
single command.

Instead of relying on `CTRL-R` to execute and recall ("that command's gotta
be here somewhere..."), desk helps shorten and document those actions with
shell aliases and functions, which are then namespaced under a particular
desk.

I have a hard time calling this a "workspace manager" with a straight
face -- it's basically just a shell script that sources another shell script in a new shell.
But I often find myself working in multiple different code trees simultaneously:
the quick context switches and namespaced commands that desk facilitates
have proven useful.

There are no dependencies other than some kind of Unix shell.

```sh
◲  desk 0.1.2

Usage:

    desk
        List the current desk and any associated aliases. If no desk
        is being used, display available desks.
    desk init
        Initialize desk configuration.
    desk (list|ls)
        List all desks along with a description.
    desk (.|go) desk-name
        Activate a desk.
    desk help
        Show this text.
    desk version
        Show version information.

Since desk spawns a shell, to deactivate and "pop" out a desk, you
simply need to exit or otherwise end the current shell process.
```

<img src='screencap.gif' width=700>

For example, given this deskfile (`~/.desk/desks/tf.sh`):
```sh
# tf.sh
#
# Description: desk for doing work on a terraform-based repository
#

cd ~/terraform-repo

# Set up AWS env variables: <key id> <secret>
set_aws_env() {
  export AWS_ACCESS_KEY_ID="$1"
  export AWS_SECRET_ACCESS_KEY="$2"
}

# Run `terraform plan` with proper AWS var config
plan() {
  terraform plan -module-depth=-1 \
    -var "access_key=${AWS_ACCESS_KEY_ID}" \
    -var "secret_key=${AWS_SECRET_ACCESS_KEY}"
}

# Run `terraform apply` with proper AWS var config
alias apply='terraform apply'
```

we'd get

```sh
$ desk . tf
$ desk

tf
desk for doing work on a terraform repo

  set_aws_env - Set up AWS env variables: <key id> <secret>
  plan - Run `terraform plan` with proper AWS var config
  apply - Run `terraform apply` with proper AWS var config
```

Basically, desk just associates a shell script (`name.sh`) with a name. When
you call `desk . name`, desk drops you into a shell where `name.sh` has been
executed, and then desk extracts out certain comments in `name.sh` for useful
rendering.

### Installing

0. `git clone git@github.com:jamesob/desk.git && cd desk`
0. `sudo make install` or `cp desk ~/bin/desk`
0. `desk init`
0. Start adding deskfiles to your config directory, e.g. `~/.desk/desks/hacking_gibson.sh`

### Deskfile rules

Deskfiles are just shell scripts, nothing more, that live in the desk config directory.
Desk does pay attention to certain kinds of comments, though.

- *description*: you can describe a deskfile by including `# Description: ...`
  somewhere in the file.

- *alias and function docs*: if the line above an alias or function is a
  comment, it will be used as documentation.

### Sharing deskfiles across computers

Of course, the desk config directory (by default `~/.desks`) can be a symlink
so that deskfiles can be stored in some centralized place, like Dropbox,
and so shared across many computers.

### Using a non-default config location

By default, desks live in `~/.desk/desks`. If you want to use some other location,
specify as much in `desk init` and then ensure you set `$DESK_DIR` to match
that location in your shell's rc file.

### Usage with OS X

Desk won't work when used strictly with `~/.bash_profile` on OS X's terminal, since
the content of `~/.bash_profile` is only executed on *login*, not shell creation, as
explained [here](http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html).

My recommendation is to use `~/.bashrc` as your general-purpose config file, then simply
have `~/.bash_profile` point to it:
```sh
# ~/.bash_profile

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
```

### Uncommon usage-case: a lightweight alternative to modulefiles

Modules package and its user interface *module* provides for the dynamic modification of the user's
environment via modulefiles, that is an ubiquitous tool when working in Unix-GNU/Linux architectures.
*module* is a powerful environment manager, but its configuration could be cumbersome and painful.
On the contrary, *desk* could be a lightweight alternative to *module*, essentially because:

+ *desk* is easy to configure, more than *Module package*;
+ *desk* is easy to use, as the common usage-case of *module*;
+ *deskfiles* constitute the only configuration files you need, merging *module* and *modulefiles*
  configuration files; moreover, *deskfiles* live in the user-space, thus they are easy to maintain.

In the following it is explained how to use *desk* as a lightweight alternative to *Module package*,
but *desk* can be surely more powerful than it is supposed to be!

Commonly, *Module package* is used to manage users environment allowing dynamic modifications, e.g. it
is common to load/unload different compilers environments for testing purposes. The most common usage
of *module* is based on the following 4 commands:

1. `module avail`: list the available *modulefiles* that can be used to change the user environment;
2. `module list`: list the presently loaded *modulefiles*;
3. `module load #module_name`: load the *modulefile* named `#module_name`;
4. `module unload #module_name`: unload the *modulefile* named `#module_name`;

For example a typical scenario could be the following:

```shell
→ module avail

------------------------ /opt/arch/modules/gcc ----------------------------------------
6.0

------------------------ /opt/arch/modules/mpi ----------------------------------------
mpich-3.0.4-gnu      mpich-3.0.4-open64   mpich-3.1.4-intel    openmpi-1.6.5-intel
mpich-3.0.4-intel    mpich-3.1.4-gnu      openmpi-1.6.5-gnu    openmpi-1.6.5-open64

---------------------- /opt/arch/modules/open64 ---------------------------------------
amd-4.5.2 sgi-5.0.0

---------------------- /opt/arch/modules/openuh ---------------------------------------
openuh-3.0.34

→ module list
No Modulefiles Currently Loaded.

→ module load mpich-3.1.4-gnu

Currently Loaded Modulefiles:
  1) mpich-3.1.4-gnu

→ module unload mpich-3.1.4-gnu

→ module list
No Modulefiles Currently Loaded.
```

The above described work-flow can be replicated (painless) by means of *desk*:

1. `desk list`: list the available *deskfiles* that can be used to change the user environment;
2. `desk`: list the presently loaded *deskfiles*;
3. `desk . #desk_name`: load the *deskfile* named `#desk_name`;
4. `exit`: unload the last loaded *deskfile*;

For example a typical scenario could be the following:

```shell
→ desk list
mpich-3.1.4-intel-15.0.3 - mpich 3.1.4 compiled with intel 15.0.3 environment
mpich-3.1.4-gnu-6.0.0 - mpich 3.1.4 compiled with gnu 6.0.0 environment
mpich-3.1.4-gnu-5.2.0 - mpich 3.1.4 compiled with gnu 5.2.0 environment
gcc-6.0 - gcc 6.0 environment

→ desk
No desk activated.

→ desk . mpich-3.1.4-gnu-6.0.0

→ desk
mpich-3.1.4-gnu-6.0.0
mpich 3.1.4 compiled with gnu 6.0.0 environment

exit

→ desk
No desk activated.
```

As an example, the *deskfile* for loading the `mpich-3.1.4-gnu-6.0.0` environment could be something like:

```bash
# mpich-3.1.4-gnu-6.0.0.sh
#
# Description: mpich 3.1.4 compiled with gnu 6.0.0 environment
#

PATH=/opt/arch/mpi/bin/mpich/3.1.4/gnu/6.0.0/bin:$PATH
LD_LIBRARY_PATH=/opt/arch/mpi/bin/mpich/3.1.4/gnu/6.0.0/lib/mpich:/opt/arch/mpi/bin/mpich/3.1.4/gnu/6.0.0/lib:$LD_LIBRARY_PATH
LD_RUN_PATH=/opt/arch/mpi/bin/mpich/3.1.4/gnu/6.0.0/lib/mpich:/opt/arch/mpi/bin/mpich/3.1.4/gnu/6.0.0/lib:$LD_RUN_PATH
MANPATH=/opt/arch/mpi/bin/mpich/3.1.4/gnu/6.0.0/share/man:$MANPATH
export PATH LD_LIBRARY_PATH LD_RUN_PATH MANPATH
```

This turns *desk* into a lightweight, configuration-painless, alternative to *Module package* tool.
