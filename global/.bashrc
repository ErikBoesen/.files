. $HOME/.private.sh

[[ $(uname) == "Darwin" ]] && mac=true
[[ $(uname) == "Linux"  ]] && linux=true

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin
if [[ $(hostname) == "mir" ]]; then
    ANDROID_HOME=$HOME/Library/Android/sdk
else
    ANDROID_HOME=/usr/local/share/android-sdk
fi
if [[ $mac == true ]]; then
    PATH=$PATH:$HOME/Library/Python/3.9/bin
    PATH=$PATH:/usr/local/texlive/2022/bin/universal-darwin
    PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin
    PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
    PATH=$PATH:$HOME/.rvm/bin
    PATH=$PATH:$HOME/Library/Android/sdk/build-tools/29.0.2
elif [[ $linux == true ]]; then
    PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin
fi

export PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home

eval "$(rbenv init - bash)"

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

        if ! [[ $branch == "master" || $branch == "main" ]]; then # TODO: Support default branches not named master
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


if [[ $mac == true ]]; then
    #char="𓆃  "
    char='ᐅ'
elif [[ $linux == true ]]; then
    if [[ $(hostname) == juno ]]; then
        char='🚀'
    else
        char='🐞'
    fi
fi

export BASH_SILENCE_DEPRECATION_WARNING=1
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
    alias suspend='systemctl suspend'
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi

alias r='. ~/.bashrc'
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

alias redb='rm -rf migrations app.db dump.rdb && flask db init && flask db migrate -m init && flask db upgrade'
alias hl='heroku logs -t -n 1000'
alias hls='heroku logs -t --source=app -n 1000'
alias hpp='heroku pg:psql'

alias ip="ifconfig | grep 'inet ' | grep -Fv 127.0.0.1 | awk '{print \$2}'"

function pgc {
    git commit -m "$(git diff --cached --name-only): $2"
}

. $HOME/.bashrc_host

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
