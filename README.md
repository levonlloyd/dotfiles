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

Install:

```
$ stow -t ~ launchd
$ for p in ~/Library/LaunchAgents/com.levon.*.plist; do
      launchctl bootstrap gui/$UID "$p"
  done
```

LaunchAgents fire at **login**, not at power-on — they need a user session.
With FileVault on there is no earlier hook worth having anyway.

The plists hardcode `/opt/homebrew/bin` in `PATH` and `/Users/levon` in
absolute paths; both need editing on an Intel Mac or under a different
username.

Check them:

```
$ launchctl print gui/$UID/com.levon.tmux        # state, run count, last exit code
$ tmux ls
$ cat ~/Library/Logs/tmux-launchd.err.log
$ cat /tmp/check-review-requests.log
```

Reload after editing a plist:

```
$ launchctl bootout gui/$UID/com.levon.tmux
$ launchctl bootstrap gui/$UID ~/Library/LaunchAgents/com.levon.tmux.plist
```
