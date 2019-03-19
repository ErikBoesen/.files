. $HOME/.private.sh

[[ $(uname) == "Darwin" ]] && mac=true
[[ $(uname) == "Linux"  ]] && linux=true

PATH=/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.local/bin
GOPATH=/usr/local/go
if [[ $mac == true ]]; then
    PATH=$PATH:$HOME/.local/homebrew/bin
    PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin
    PATH=$PATH:$HOME/Library/Python/3.6/bin
    PATH=$PATH:/usr/local/texlive/2018/bin/x86_64-darwin
    PATH=$PATH:$HOME/moos-ivp/bin:$HOME/moos-ivp-erik/bin
    PATH=$PATH:$HOME/.rvm/bin
    PATH=$PATH:$HOME/.rvm/gems/ruby-2.4.4/bin
    GOPATH=$HOME/.local/go
elif [[ $linux == true ]]; then
    PATH=$PATH:$HOME/.gem/ruby/2.4.0/bin
    PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin
fi
PATH=$PATH:$HOME/moos-ivp/bin:$HOME/moos-ivp-erik/bin:$HOME/moos-ivp-aquaticus/bin
PATH=$PATH:$HOME/Qt/5.11.1/clang_64/bin

PATH=$PATH:$GOPATH/bin
export PATH
export GOPATH

# Aquaticus
#export LIBRARY_PATH=/opt/local/lib
#export IVP_BEHAVIOR_DIRS=$HOME/moos-ivp/lib:$HOME/moos-ivp-erik/lib:$HOME/moos-ivp-aquaticus/lib

unset PROMPT_COMMAND

# Instantly append commands to history
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

export EDITOR=vim

umask 077

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
    alias burn='git clone https://github.com/ErikBoesen/burn ~/burn; ~/burn/burn.sh'

    alias slp='pmset sleepnow'
    alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
    # Preview images
    function eog {
        (qlmanage -p $@ &>/dev/null &)
    }

    function vup   { ssh mir -T "pamixer --increase $1"; }
    function vdown { ssh mir -T "pamixer --decrease $1"; }
    alias vim="$HOME/.local/homebrew/bin/vim"

    # Circumvent GMHS tmux blacklisting
    alias tmux="$HOME/.local/homebrew/Cellar/tmux/2.7/bin/mtx"
elif [[ $linux == true ]]; then
    alias ls='ls --color=auto'
    alias l='ls -lah --color=auto'
    alias torrent='transmission-cli'
    function wallpaper {
        gsettings set org.gnome.desktop.background picture-uri file://"$(realpath "$1")"
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

alias git='hub'
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gst='git status -s' # Standard ZSH alias doesn't use -s
alias gs='git status -s' # Account for missing t key
alias gd='git diff'
alias glo='git log --oneline --decorate'
alias gsta='git stash save'
alias gstp='git stash pop'

alias texclean='rm -fv *.{aux,bbl,blg,log,out,pdf,synctex.gz,pyg,fls,fdb_latexmk,dvi}'
alias cdaq='cd ~/moos-ivp-aquaticus/missions/aquaticus2.0'
# I will eventually memorize this and remove it.
alias fix_perms='echo "chmod -R u=rwX,go=rX"'
alias ktm='(ktm &)'
alias sl='ls'
alias 1418='wif connect -n 1418'
alias stud='wif connect -n FCCPS-GMSTUDENT1819'
function gorm {
    rm -rf $GOPATH/{pkg/*/*/*/$1.*,src/*/*/$1} 2>/dev/null
}

alias r='. ~/.bashrc'
