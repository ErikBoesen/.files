PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.local/bin:/opt/local/bin
export PATH

function git_prompt {
    if [[ -d .git ]] || git rev-parse --git-dir > /dev/null 2>&1; then
        printf " \e[36m∑:[$(git rev-parse --abbrev-ref HEAD)]\e[0m"
        if ! [[ -z $(git status --porcelain) ]]; then
            printf ' \e[33m△\e[0m'
        fi
    fi
}
# TODO: Broken
function status_prompt {
    if [[ $? == 0 ]]; then
        printf '\e[32m'
    else
        printf '\e[31m'
    fi
    printf '$\e[0m'
}
function chpwd {    
    PS1='\[\e[34m\]\W\[\e[0m\]$(git_prompt) $(status_prompt) '
}
chpwd

function    cd { builtin    cd "$@"; chpwd; }
function pushd { builtin pushd "$@"; chpwd; }
function  popd { builtin  popd "$@"; chpwd; }

alias g="git"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gst="git status"
alias gs="git status"
alias gd="git diff"
alias glo="git log --oneline --decorate"

alias ls="ls -G"
