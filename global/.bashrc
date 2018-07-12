PATH=/opt/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.local/bin
PATH=$PATH:$HOME/moos-ivp/bin:$HOME/moos-ivp-erik/bin:$HOME/moos-ivp-aquaticus-aro/bin
PATH=$PATH:$HOME/Qt/5.11.1/clang_64/bin
export PATH

# Aquaticus
export LIBRARY_PATH=/opt/local/lib
export IVP_BEHAVIOR_DIRS=$HOME/moos-ivp/lib:$HOME/moos-ivp-erik/lib:$HOME/moos-ivp-aquaticus-aro/lib

unset PROMPT_COMMAND

# Instantly append commands to history
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

function dir_prompt {
    if [[ -d .git ]] || git rev-parse --git-dir > /dev/null 2>&1; then
        printf "\[\e[34;4m\]"
        printf "\W"
        branch=$(git rev-parse --abbrev-ref HEAD)
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
function status_prompt {
    if (( $1 == 0)); then
        printf "\[\e[32m\]"
    else
        printf "\[\e[31m\]"
    fi
    printf "\$\[\e[0m\]"
}
function chpwd {
    PS1="$(dir_prompt) $(status_prompt $1) "
}
PROMPT_COMMAND="chpwd \$?;$PROMPT_COMMAND"

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

alias cdaq="cd ~/moos-ivp-aquaticus-aro/missions/aquaticus1.2.1"

alias ls="ls -G"
alias dump="lynx -width=$(tput cols) --dump"
alias sl="pmset sleepnow"
alias r=". ~/.bashrc"
alias nw="networksetup -setairportnetwork en1"
