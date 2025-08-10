# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
export XDG_CONFIG=/etc/xdg

# zsh history
HISTFILE="$XDG_CACHE_HOME"/zsh_history
HISTSIZE=10000
SAVEHIST=10000
bindkey -e

# Completion
zstyle :compinstall filename $HOME/.zshrc
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zcompdump-$ZSH_VERSION-$HOST
zstyle ':completion:*' menu select

# General tweaks
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export TERMINAL="ghostty"
export DRIVES_MOUNTPOINT=$HOME/mounts

export PATH=$PATH:$HOME/.local/bin:$HOME/scripts

export GPG_TTY=$(tty)

# Vim mode
bindkey -v
export KEYTIMEOUT=1

bindkey "^?" backward-delete-char

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.
precmd() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Restic
export RESTIC_REPOSITORY=$DRIVES_MOUNTPOINT/synology/backup/restic/$HOST
export RESTIC_PASSWORD_FILE=$HOME/.resticpw-$HOST

# Alias'
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias -- 'l'='eza -F -x --icons=auto'
alias ff='fastfetch'
alias lg='lazygit'
alias hl='rg --passthru'
alias cleanup='paru -Sc && restic forget --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --keep-yearly 75'
alias installparu='cd $(mktemp -d) && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si && cd ~'
alias installyay='cd $(mktemp -d) && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd ~'
alias spotikill='flatpak kill com.spotify.Client'
alias stars='astroterm --color --constellations --speed 1000 --fps 64 --city Amsterdam'
# alias pokeslots='~/pokeslots'
alias browserestic='restic ls latest --ncdu | ncdu -f -'
alias gentoomount='sudo mount /dev/nvme0n1p2 /mnt/gentoo -o subvol=@gentoo && sudo mount /dev/nvme0n1p2 /mnt/gentoo/home -o subvol=@home && sudo mount /dev/nvme0n1p1 /mnt/gentoo/boot/efi'
alias make.conf='sudo nvim /etc/portage/make.conf'
alias @world='sudo emerge --ask --verbose --update --deep --newuse @world'
alias flake.nix='nvim ~/.config/nix/flake.nix'
alias ssh='TERM=xterm-256color ssh'

if command -v equery &>/dev/null; then
    alias eqf='equery f'
    alias equ='equery u'
    alias eqh='equery h'
    alias eqa='equery a'
    alias eqb='equery b'
    alias eql='equery l'
    alias eqd='equery d'
    alias eqg='equery g'
    alias eqk='equery k'
    alias eqm='equery m'
    alias eqy='equery y'
    alias eqs='equery s'
    alias eqw='equery w'
fi

# xdg-ninja
export CARGO_HOME="$XDG_DATA_HOME"/cargo
#export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
#export GNUPGHOME="$XDG_DATA_HOME"/gnupg
#export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
#export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
#export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
#export W3M_DIR="$XDG_DATA_HOME"/w3m
#alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

# Starship
eval "$(starship init zsh)"

# Zsh plugins
setopt null_glob
if [[ "$(uname)" =~ Darwin ]] ; then
    source_path=(
	    $(brew --prefix)/share/zsh-autosuggestions
	    $(brew --prefix)/share/zsh-syntax-highlighting
    )
else
    source_path=(
        /usr/share/zsh/plugins/*
        /usr/share/zsh/site-functions
    )
fi
# Set up fzf key bindings and fuzzy completion
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

for plugin in $^source_path/*.zsh; do
    source $plugin
done

# Pokemon art on open
if command -v krabby &>/dev/null; then
  krabby random --no-title
fi

# Mini fetch on open :3
if command -v fastfetch &>/dev/null; then
  fastfetch -l small -s Title:Separator:Kernel:Shell:Memory:Uptime:Packages
fi

# Tmux on startup
#if [ -z "$TMUX" ]
#then
#    tmux attach -t "main" || tmux new -s "main" && exit
#fi

