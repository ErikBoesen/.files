. $HOME/.private.sh

[[ $(uname) == "Darwin" ]] && mac=true
[[ $(uname) == "Linux"  ]] && linux=true

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.local/bin
GOPATH=/usr/local/go
ANDROID_HOME=$HOME/Library/Android/sdk
if [[ $mac == true ]]; then
    PATH=$PATH:$HOME/.local/homebrew/bin
    PATH=$PATH:$HOME/Library/Python/3.7/bin
    PATH=$PATH:/usr/local/texlive/2019/bin/x86_64-darwin
    PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin
    PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
    PATH=$PATH:$HOME/.rvm/bin
    PATH=$PATH:$HOME/Library/Android/sdk/build-tools/29.0.2
elif [[ $linux == true ]]; then
    PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin
fi

PATH=$PATH:$GOPATH/bin
export PATH
export GOPATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home

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
    # Preview images
    function eog {
        (qlmanage -p $@ &>/dev/null &)
    }
elif [[ $linux == true ]]; then
    alias ls='ls --color=auto'
    alias l='ls -lah --color=auto'
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

alias r='. ~/.bashrc'
alias git='hub'
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

alias dsw='find . -iname ".*.sw*" -delete'
alias texclean='rm -fv *.{aux,bbl,blg,log,out,synctex.gz,pyg,fls,fdb_latexmk,dvi}'
alias sl='ls'
alias dist='rm -rf dist && python3 setup.py sdist && twine upload dist/*'

alias nr="native-run android --app $HOME/src/Comethru/app/platforms/android/app/build/outputs/apk/debug/app-debug.apk"
alias nrd="native-run android --app $HOME/src/Comethru/app/platforms/android/app/build/outputs/apk/debug/app-debug.apk --debug"
alias hl="heroku logs -t"
alias hls="heroku logs -t --source=app"

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
