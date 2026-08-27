# Levon Lloyd's dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### Git

```
brew install git
```

### Stow

```
brew install stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com/levonlloyd/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```
$ stow .
```

## macOS: start the tmux server at login

The `launchd` package ships `com.levon.tmux`, a LaunchAgent that brings up a
detached `_persistent` session so a tmux server is always running in the
background.

```
$ stow -t ~ launchd
$ launchctl bootstrap gui/$UID ~/Library/LaunchAgents/com.levon.tmux.plist
```

`RunAtLoad` fires at **login**, not at power-on — LaunchAgents need a user
session. With FileVault on there is no earlier hook worth having anyway.

The plist hardcodes `/opt/homebrew/bin` in `PATH`; on an Intel Mac change that
to `/usr/local/bin`.

Check it:

```
$ launchctl print gui/$UID/com.levon.tmux
$ tmux ls
$ cat ~/Library/Logs/tmux-launchd.err.log
```

To reload after editing the plist:

```
$ launchctl bootout gui/$UID/com.levon.tmux
$ launchctl bootstrap gui/$UID ~/Library/LaunchAgents/com.levon.tmux.plist
```
