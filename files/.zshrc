. $HOME/.private.sh

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin
export PATH=$PATH:$HOME/.gem/ruby/2.0.0/bin
export GOPATH=/usr/local/go
export PATH=$PATH:$GOPATH/bin

export ZSH=/Users/boesene/.oh-my-zsh

ZSH_THEME="erkbsn"
plugins=(git)
. $ZSH/oh-my-zsh.sh

alias burn="git clone https://github.com/ErikBoesen/burn ~/burn; ~/burn/burn.sh"
alias notes="cd ~/src/ibhlcs/notes && jupyter notebook"

function tba {
    curl -s "https://www.thebluealliance.com/api/v3/$1?X-TBA-Auth-Key=$TBAKEY"
    echo
}
function gorm {
    rm -rf $GOPATH/{pkg/*/*/*/$1.*,src/*/*/$1} 2>/dev/null
}

function sudo { ssh root@localhost -t "cd $(pwd); $@" 2>/dev/null }
function su   { ssh root@localhost 2>/dev/null }
