. $HOME/.private.sh

[[ $(uname) == "Darwin" ]] && mac=true
if [[ $(uname) == "Linux"  ]]; then
    linux=true
    [[ $(hostname) == "juno" ]] && server=true
fi
[[ $(hostname) == "iceland" ]] && iceland=true

PATH=/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.local/bin
if [[ $mac == true ]]; then
    PATH=$PATH:$HOME/.gem/ruby/2.0.0/bin
    PATH=$PATH:$HOME/Library/Python/3.6/bin
    PATH=$PATH:/usr/local/texlive/2017/bin/x86_64-darwin
    PATH=$PATH:$HOME/moos-ivp/bin:$HOME/moos-ivp-erik/bin
    PATH=$PATH:$HOME/.rvm/bin
    PATH=$PATH:$HOME/.rvm/gems/ruby-2.4.4/bin
elif [[ $linux == true ]]; then
    PATH=$PATH:$HOME/.gem/ruby/2.4.0/bin
    PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin
fi
PATH=$PATH:$HOME/moos-ivp/bin:$HOME/moos-ivp-erik/bin:$HOME/moos-ivp-aquaticus/bin
PATH=$PATH:$HOME/Qt/5.11.1/clang_64/bin

export GOPATH=/usr/local/go
PATH=$PATH:$GOPATH/bin
export PATH

# Temporarily disabled; will recurse if you self-ssh
#if [[ -z $TMUX ]]; then
#    (tmux a || tmux) && exit $?
#fi

# Aquaticus
export LIBRARY_PATH=/opt/local/lib
export IVP_BEHAVIOR_DIRS=$HOME/moos-ivp/lib:$HOME/moos-ivp-erik/lib:$HOME/moos-ivp-aquaticus/lib

unset PROMPT_COMMAND

# Instantly append commands to history
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

export EDITOR=vim
# For ddgr/googler
export DISABLE_PROMPT_COLOR=1

umask 077

function dir_prompt {
    if [[ -d .git ]] || git rev-parse --git-dir &>/dev/null; then
        printf "\[\e[34;4m\]"
        printf "\W"
        branch=$(git symbolic-ref --short HEAD)

        if ! [[ $branch == "master" ]]; then # TODO: Support default branches not named master
            printf "\[\e[0;2m\]:$branch"
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
    if [[ $server == true ]]; then
        char="∑"
    fi
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
    alias ls="ls -G"
    alias l="ls -Glah"
    alias git="hub"
    alias burn="git clone https://github.com/ErikBoesen/burn ~/burn; ~/burn/burn.sh"
    alias notes="cd ~/src/ibhlcs/notes && jupyter notebook"
    alias tc="texcount *.tex"
    alias texclean="rm *.{aux,bbl,blg,log,out,pdf,synctex.gz}"
    alias lockscreen="sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText"

    alias rmnetconf="sudo rm /Library/Preferences/SystemConfiguration/{com.apple.airport.preferences.plist,com.apple.network.eapolclient.configuration.plist,com.apple.wifi.message-tracer.plist,NetworkInterfaces.plist,preferences.plist}"
    alias curr="spotify play uri spotify:user:erikboesen:playlist:3WiQZxcyDiMGyJOg4MqwqZ"
    alias sl="ls"
    alias slp="pmset sleepnow"
    alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
    function t {
        (cd $HOME/src/tfix && bundle exec t $@)
    }

    function gorm {
        rm -rf $GOPATH/{pkg/*/*/*/$1.*,src/*/*/$1} 2>/dev/null
    }

    #function sudo { ssh root@localhost -T "export PATH=$PATH; cd '$(pwd)'; '$@'" }
    #function su   { ssh root@localhost -o LogLevel=QUIET }
    if [[ $iceland == true ]]; then
        alias pip3="pip"
    else
        alias vim="/usr/local/bin/vim"
    fi
elif [[ $linux == true ]]; then
    alias ls="ls --color=auto"
    alias l="ls -lah --color=auto"
    alias torrent="transmission-cli"

    if [[ $server == true ]]; then
        alias update="tmux new-session -s updates bash -c 'sudo zypper update -y && rm ~/.update' >/dev/null"
        alias leoupd="cd ~/leopard;git pull;zip -r ~/www/leopard.zip ."

        printf '\r\n'
        printf "  \e[36mJ\e[32m U\e[33m N\e[31m O 🚀\e[0m\n"
        printf "  \e[34m$(uptime | awk '{print $3 "d " substr($5, 1, length($5)-1)}').\e[0m\n"
    else
        alias update="tmux new-session -s updates bash -c 'sudo pacman -Syu --noconfirm && rm ~/.update' >/dev/null"
        alias suspend="systemctl suspend"

        alias pbcopy="xsel --clipboard --input"
        alias pbpaste="xsel --clipboard --output"
        alias vup="pamixer --increase"
        alias vdown="pamixer --decrease"

        alsi -l
    fi

    if [ -e $HOME/.update ]; then
        printf "Check for updates? $fg[green](y):$reset_color "
        read response
        if [[ "$response" =~ ^[yY]?$ ]]; then
            update
        fi
    fi
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
    espera "$1" && ssh "$1"
}

alias g="git"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gb="git branch"
alias gco="git checkout"
alias gst="git status -s" # Standard ZSH alias doesn't use -s
alias gs="git status -s" # Account for missing t key
alias gd="git diff"
alias glo="git log --oneline --decorate"
alias gsta='git stash save'
alias gstp='git stash pop'

# Silence unnecessary gdb logs
alias gdb="gdb -q"

alias cdaq="cd ~/moos-ivp-aquaticus/missions/aquaticus2.0"
# I will eventually memorize this and remove it.
alias fix_perms='echo "chmod -R u=rwX,go=rX"'
alias ktm="(ktm &)"

alias dump='lynx -width=$(tput cols) --dump'
alias r=". ~/.bashrc"
function tba {
    curl -s "https://www.thebluealliance.com/api/v3/$1?X-TBA-Auth-Key=$TBAKEY"
    echo
}

# Startup logs
#td list
