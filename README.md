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

## macOS: LaunchAgents

The `launchd` package ships the personal agents under
`~/Library/LaunchAgents`. Vendor and MDM plists (Homebrew, Google, Rippling,
SentinelOne, …) are not tracked here — only `com.levon.*`.

| Label | Trigger | Does |
| --- | --- | --- |
| `com.levon.tmux` | at login | starts a detached `_persistent` tmux session so a server is always up |
| `com.levon.check-review-requests` | every 5 min | runs `~/.claude/hooks/check-review-requests.sh` |
| `com.levon.eod-reminder` | Mon–Fri 16:45 | notification nagging for the `/eod` shutdown ritual |

`check-review-requests` needs `~/.claude/hooks`, which is a symlink into the
separate `claude-skills` repo — clone that first or the job fails every five
minutes against a missing script.

All snippets here are **fish** — this repo's shell. fish has no `$UID`, hence
`(id -u)`, and its loops end with `end` rather than `done`.

Install:

```
$ stow -t ~ launchd
$ for p in ~/Library/LaunchAgents/com.levon.*.plist
      launchctl bootstrap gui/(id -u) $p
  end
```

LaunchAgents fire at **login**, not at power-on — they need a user session.
With FileVault on there is no earlier hook worth having anyway.

The plists hardcode `/opt/homebrew/bin` in `PATH` and `/Users/levon` in
absolute paths; both need editing on an Intel Mac or under a different
username.

### On a machine that already has these plists

`stow` aborts when the target exists as a real file, which is the case on any
machine set up before this package existed:

```
cannot stow ... over existing target ... since neither a link nor a directory
```

Do **not** fix that with `stow --adopt`. Adopt moves the live file *into* the
repo and then links to it, overwriting the tracked version with whatever the
machine happens to have — silently reverting any improvement made here. Unload,
delete, then stow:

```
$ for l in tmux check-review-requests eod-reminder
      launchctl bootout gui/(id -u)/com.levon.$l
  end
$ rm ~/Library/LaunchAgents/com.levon.{tmux,check-review-requests,eod-reminder}.plist
$ stow -t ~ launchd
$ for p in ~/Library/LaunchAgents/com.levon.*.plist
      launchctl bootstrap gui/(id -u) $p
  end
```

Safe to run while attached to tmux — booting out `com.levon.tmux` does not
touch the running server, only what happens at next login.

Check them:

```
$ launchctl print gui/(id -u)/com.levon.tmux        # state, run count, last exit code
$ tmux ls
$ cat ~/Library/Logs/tmux-launchd.err.log
$ cat /tmp/check-review-requests.log
```

Reload after editing a plist:

```
$ launchctl bootout gui/(id -u)/com.levon.tmux
$ launchctl bootstrap gui/(id -u) ~/Library/LaunchAgents/com.levon.tmux.plist
```
