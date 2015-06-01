source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U compinit promptinit colors
compinit
promptinit
colors

PROMPT="
%{$fg[red]%} »  %{$reset_color%}"
RPROMPT="%{$fg[black]%}%~%{$reset_color%}"

setopt AUTO_CD
setopt CORRECT
setopt completealiases
setopt append_history
setopt share_history
setopt hist_verify
setopt hist_ignore_all_dups
export HISTFILE="${HOME}"/.zsh-history
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors 'reply=( "=(#b)(*$VAR)(?)*=00=$color[green]=$color[bg-green]" )'
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=30;41'
zstyle ':completion:*:*:*:*:users' list-colors '=*=$color[green]=$color[red]'
zstyle ':completion:*' menu select

bindkey -v

conf() {
    case $1 in
        bspwm)          vim ~/.config/bspwm/bspwmrc ;;
        sxhkd)          vim ~/.config/sxhkd/sxhkdrc ;;
        vim)            vim ~/.vimrc ;;
        zsh)            vim ~/.zshrc && source ~/.zshrc ;;
        Xresources)     vim ~/.Xresources && xrdb ~/.Xresources ;; 
        *)              echo "Unknown application: $1" ;;
    esac
}

# sudo
alias pacman='sudo pacman'

# tar
alias tarzip='unzip'
alias tarx='tar -xvf'
alias targz='tar -zxvf'
alias tarbz2='tar -jxvf'

# scripts
pathdirs=(
    ~/.scripts
)

for dir in $pathdirs; do
    if [ -d $dir ]; then
        path+=$dir
    fi
done

export EDITOR='vim'

# nvm
source /usr/share/nvm/init-nvm.sh
