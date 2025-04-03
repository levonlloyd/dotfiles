if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_add_path ~/.local/share/bob/nvim-bin
    fish_add_path ~/.config/git
    fish_add_path ~/.cargo/bin
    fish_add_path /opt/homebrew/opt/fzf/bin

    abbr -a ls exa
    abbr -a cat bat
    abbr -a cd z
    abbr -a cdi zi
    abbr -a gs git status

    rtx activate fish | source
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
    eval "$(/opt/homebrew/bin/brew shellenv)"

end
