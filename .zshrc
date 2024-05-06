export PATH=/home/levon/.cargo/bin:/home/levon/.local/share/bob/nvim-bin:/home/levon/.local/bin:$PATH
export CC=/usr/bin/gcc-10
export CXX=/usr/bin/g++-10
export CUDA_ROOT=/usr/local/cuda
export EDITOR=nvim

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.localaliases" ]] && source "$HOME/.localaliases"
# exa for ls
alias ls="exa"
alias ll="exa -alh"
alias tree="exa --tree"

alias cat="bat"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

eval "$(~/.cargo/bin/rtx activate zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
