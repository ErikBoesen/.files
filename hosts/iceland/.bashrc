PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.local/bin:/opt/local/bin
PATH=$PATH:$HOME/moos-ivp/bin:$HOME/moos-ivp-erik/bin
export PATH

function git_prompt {
    if [[ -d .git ]] || git rev-parse --git-dir > /dev/null 2>&1; then
        printf "\[\e[36m\]:\[\e[4m\]"
        branch=$(git rev-parse --abbrev-ref HEAD)
        if [[ $branch == "master" ]]; then # TODO: Support default branches not named master
            printf "π"
        else
            printf "$branch"
        fi
        printf "\[\e[0m\]"
        if ! [[ -z $(git status --porcelain) ]]; then
            printf " \[\e[33m\]△\[\e[0m\]"
        fi
    fi
}
function chpwd {    
    PS1="\[\e[32m\]\W\[\e[0m\]$(git_prompt) \[\e[34m\]\$\[\e[0m\] "
}
PROMPT_COMMAND="chpwd;$PROMPT_COMMAND"

# Instantly append commands to history
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

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

alias ls="ls -G"
