. $HOME/.private.sh

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin
PATH=$PATH:$HOME/.gem/ruby/2.0.0/bin
GOPATH=/usr/local/go
PATH=$PATH:$GOPATH/bin
PATH=$PATH:/usr/local/texlive/2017/bin/x86_64-darwin
PATH=$PATH:$HOME/moos-ivp/bin
PATH=$PATH:$HOME/moos-ivp-erik/bin
export PATH

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="erkbsn"
plugins=(git svn)
. $ZSH/oh-my-zsh.sh

alias burn="git clone https://github.com/ErikBoesen/burn ~/burn; ~/burn/burn.sh"
alias notes="cd ~/src/ibhlcs/notes && jupyter notebook"
alias tc="texcount *.tex"
alias texclean="rm *.{aux,bbl,blg,log,out,pdf,synctex.gz"
alias gs="gst"

alias vim="/usr/local/bin/vim"
alias ls="ls -GF"
function tba {
    curl -s "https://www.thebluealliance.com/api/v3/$1?X-TBA-Auth-Key=$TBAKEY"
    echo
}
function gorm {
    rm -rf $GOPATH/{pkg/*/*/*/$1.*,src/*/*/$1} 2>/dev/null
}

function sudo { ssh root@localhost -T "export PATH=$PATH; cd '$(pwd)'; $@" }
function su   { ssh root@localhost -o LogLevel=QUIET }
