export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin
export PATH=$PATH:$HOME/.gem/ruby/2.0.0/bin
export PATH=$PATH:/usr/local/Cellar/qt/5.10.0_1/bin


export GOPATH=/usr/local/go
export PATH=$PATH:$GOPATH/bin
# Path to oh-my-zsh installation.
export ZSH=/Users/boesene/.oh-my-zsh

ZSH_THEME="erkbsn"

plugins=(git)

. $ZSH/oh-my-zsh.sh

alias rmss="mv $HOME/Desktop/Screen\ Shot* ~/.Trash"

alias burn="git clone https://github.com/ErikBoesen/setdown ~/setdown ; ssh root@localhost -t \"screen bash -c '/Users/boesene/setdown/setdown.sh'\""
alias python="python3"
alias notes="cd ~/ibhlcs/notes && jupyter notebook"

function tba() {
    curl -s "https://www.thebluealliance.com/api/v3/$1?X-TBA-Auth-Key=8DNvjqtGDXACNOUVNoKO1hbjvLJniGvqgR9Q8ikCieCygL3m3mK1QV7rlVaU7lDv"
    echo
}

function gorm() {
    rm -rf $GOPATH/{pkg/*/*/*/$1.*,src/*/*/$1} 2>/dev/null
}

function sudo() { ssh root@localhost -t "$@" 2>/dev/null }
function su()   { ssh root@localhost 2>/dev/null }

#printf '\r\n'
#neofetch

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

alias dep="python3 robot/robot.py deploy"
