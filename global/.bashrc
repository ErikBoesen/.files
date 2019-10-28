. $HOME/.private.sh

[[ $(uname) == "Darwin" ]] && mac=true
[[ $(uname) == "Linux"  ]] && linux=true

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.local/bin
GOPATH=/usr/local/go
if [[ $mac == true ]]; then
    PATH=$PATH:$HOME/.local/homebrew/bin
    PATH=$PATH:$HOME/Library/Python/3.7/bin
    PATH=$PATH:/usr/local/texlive/2019/bin/x86_64-darwin
    PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin
    PATH=$PATH:/Applications/microchip/xc16/v1.24/bin
elif [[ $linux == true ]]; then
    PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin
fi

PATH=$PATH:$GOPATH/bin
export PATH
export GOPATH

unset PROMPT_COMMAND
# Instantly append commands to history
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
# Prevent duplicate adjacent commands
export HISTCONTROL=ignoreboth:erasedups

export EDITOR=vim

umask 002

function dir_prompt {
    if [[ -d .git ]] || git rev-parse --git-dir &>/dev/null; then
        printf "\[\e[34;4m\]"
        printf "\W"
        branch=$(git symbolic-ref --short HEAD)

        if ! [[ $branch == "master" ]]; then # TODO: Support default branches not named master
            printf "\[\e[0;90m\]:$branch"
        fi
        printf "\[\e[0m\]"
        if ! [[ -z $(git status --porcelain) ]]; then
            printf " \[\e[33m\]△\[\e[0m\]"
        fi
    else
        printf "\[\e[34m\]\W\[\e[0m\]"
    fi
}
char="_"
if [[ $mac == true ]]; then
    char=">"
elif [[ $linux == true ]]; then
    char="$"
    #char="∑"
fi
function status_prompt {
    if [[ $1 -eq 0 ]]; then
        printf "\[\e[32m\]"
    else
        printf "\[\e[31m\]"
    fi
    printf "$char\[\e[0m\]"
}
function chpwd {
    PS1="$(dir_prompt) $(status_prompt $1) "
}
PROMPT_COMMAND="chpwd \$?;$PROMPT_COMMAND"

if [[ $mac == true ]]; then
    alias ls='ls -G'
    alias l='ls -Glah'

    alias slp='pmset sleepnow'
    alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
    # Preview images
    function eog {
        (qlmanage -p $@ &>/dev/null &)
    }

    function vup   { ssh mir -T "pamixer --increase $1"; }
    function vdown { ssh mir -T "pamixer --decrease $1"; }
elif [[ $linux == true ]]; then
    alias ls='ls --color=auto'
    alias l='ls -lah --color=auto'
    alias torrent='transmission-cli'
    function wallpaper {
        gsettings set org.gnome.desktop.background picture-uri file://"$(realpath "$1")"
    }
    function lockscreen {
        gsettings set org.gnome.desktop.screensaver picture-uri file://"$(realpath "$1")"
    }
    alias suspend='systemctl suspend'
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    alias vup='pamixer --increase'
    alias vdown='pamixer --decrease'
fi

function espera {
    chars="-\\|/"
    tries=0
    while ! ping -t 1 -c 1 -n "$1" &> /dev/null; do
        ((tries++))
        printf "\r\e[0m$1 \e[32m${chars:$((tries%4)):1}"
        sleep 0.2
    done
    printf "\r"
}
function essh {
    # Espera hasta que esté listo pa conectarse
    # TODO: Strip username and/or read from SSH config
    espera "$1" && ssh "$1"
}

alias r='. ~/.bashrc'
alias git='hub'
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gph='git push heroku & git push; wait'
alias gl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gst='git status -s' # Standard ZSH alias doesn't use -s
alias gs='git status -s' # Account for missing t key
alias gd='git diff'
alias glo='git log --oneline --decorate'
alias gsta='git stash save'
alias gstp='git stash pop'

alias texclean='rm -fv *.{aux,bbl,blg,log,out,synctex.gz,pyg,fls,fdb_latexmk,dvi}'
# I will eventually memorize this and remove it.
alias fix_perms='echo "chmod -R u=rwX,go=rX"'
alias sl='ls'
alias dist='rm -rf dist && python3 setup.py sdist && twine upload dist/*'

function gorm {
    rm -rf $GOPATH/{pkg/*/*/*/$1.*,src/*/*/$1} 2>/dev/null
}

function pgc {
    git commit -m "$(git diff --cached --name-only): $2"
}

function cg {
    type=$1
    shift
    scope=$1
    shift
    git commit -m "$type($scope): $@ $(git rev-parse --abbrev-ref HEAD)"
}

freak() {
    for ((;;)); do
        echo -e "\a"
        sleep 0.5
    done
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
