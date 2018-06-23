. $HOME/.private.sh

[[ $(uname) -eq "Darwin" ]] && mac=true
if [[ $(uname) -eq "Linux"  ]]; then
    linux=true
    [[ $(hostname) -eq "juno" ]] && server=true
fi

if $mac; then
    PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin
    PATH=$PATH:$HOME/.gem/ruby/2.0.0/bin
    export GOPATH=/usr/local/go
    PATH=$PATH:$GOPATH/bin
    PATH=$PATH:/usr/local/texlive/2017/bin/x86_64-darwin
    PATH=$PATH:$HOME/moos-ivp/bin
    PATH=$PATH:$HOME/moos-ivp-erik/bin
    export PATH
elif $linux; then
    PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.local/bin
    PATH=$PATH:/home/erik/.gem/ruby/2.4.0/bin
    export GOPATH=/usr/local/go
    PATH=$PATH:$GOPATH/bin
    export PATH
fi

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="erkbsn"
plugins=(git)
. $ZSH/oh-my-zsh.sh

umask 077

if $mac; then
    alias burn="git clone https://github.com/ErikBoesen/burn ~/burn; ~/burn/burn.sh"
    alias notes="cd ~/src/ibhlcs/notes && jupyter notebook"
    alias tc="texcount *.tex"
    alias texclean="rm *.{aux,bbl,blg,log,out,pdf,synctex.gz"
    alias gs="gst"
    alias lockscreen="sudo defaults remove /Library/Preferences/com.apple.loginwindow LoginwindowText"

    alias vim="/usr/local/bin/vim"
    alias ls="ls -GF"

    function gorm {
        rm -rf $GOPATH/{pkg/*/*/*/$1.*,src/*/*/$1} 2>/dev/null
    }

    function sudo { ssh root@localhost -T "export PATH=$PATH; cd '$(pwd)'; $@" }
    function su   { ssh root@localhost -o LogLevel=QUIET }
elif $linux; then
    if $server; then
        alias torrent="transmission-cli"
        alias http="sudo python3 -m http.server 80"

        alias update="tmux new-session -s updates bash -c 'sudo zypper update -y && rm ~/.update' >/dev/null"
        alias leoupd="cd ~/leopard;git pull;zip -r ~/www/leopard.zip ."

        printf '\r\n'
        echo "  $fg[cyan]J$fg[green] U$fg[yellow] N$fg[red] O 🚀$reset_color"
        echo "  $fg[blue]$(uptime | awk '{print $3 "d " substr($5, 1, length($5)-1)}').$reset_color"

    else
        alias update="tmux new-session -s updates bash -c 'sudo pacman -Syu --noconfirm && rm ~/.update' >/dev/null"
        alias suspend="systemctl suspend"

        alias pbcopy="xsel --clipboard --input"
        alias pbpaste="xsel --clipboard --output"
        alias vup="pamixer --increase"
        alias vdown="pamixer --decrease"

        alias torrent="transmission-cli"

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

function tba {
    curl -s "https://www.thebluealliance.com/api/v3/$1?X-TBA-Auth-Key=$TBAKEY"
    echo
}
