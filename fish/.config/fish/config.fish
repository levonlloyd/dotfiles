if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_add_path ~/.local/share/bob/nvim-bin
    fish_add_path ~/.local/bin
    fish_add_path ~/.config/git
    fish_add_path ~/.cargo/bin
    fish_add_path /opt/homebrew/opt/fzf/bin
    fish_add_path /Applications/Obsidian.app/Contents/MacOS

    set -gx EDITOR nvim

    abbr -a ls eza
    abbr -a cat bat
    abbr -a cd z
    abbr -a cdi zi
    abbr -a gs git status
    abbr -a gd git diff
    abbr -a gco git checkout
    abbr -a gl git l
    abbr -a gb git branch
    abbr -a gmb git mb
    abbr -a ai cd ~/code/ai-service/
    abbr -a gca git commit --amend --no-edit -a

    eval "$(/opt/homebrew/bin/brew shellenv)"
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
    fnm env --use-on-cd --shell fish | source

end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/levon/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/levon/Downloads/google-cloud-sdk/path.fish.inc'; end
