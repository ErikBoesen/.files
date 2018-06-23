. $HOME/.private.sh

[[ $(uname) -eq "Darwin" ]] && mac=true
[[ $(uname) -eq "Linux"  ]] && linux=true

if $mac; then
    PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin
    PATH=$PATH:$HOME/.gem/ruby/2.0.0/bin
    export GOPATH=/usr/local/go
    PATH=$PATH:$GOPATH/bin
    PATH=$PATH:/usr/local/texlive/2017/bin/x86_64-darwin
    PATH=$PATH:$HOME/moos-ivp/bin
    PATH=$PATH:$HOME/moos-ivp-erik/bin
    export PATH
else
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

else
    alias update="tmux new-session -s updates bash -c 'sudo pacman -Syu --noconfirm && rm ~/.update' >/dev/null"
    alias suspend="systemctl suspend"

    alias pbcopy="xsel --clipboard --input"
    alias pbpaste="xsel --clipboard --output"
    alias vup="pamixer --increase"
    alias vdown="pamixer --decrease"

    alias torrent="transmission-cli"

    function tba {
        curl -s "https://www.thebluealliance.com/api/v3/$1?X-TBA-Auth-Key=$TBAKEY"
        echo
    }

    alsi -l

    if [ -e $HOME/.update ]; then
    	printf "Check for updates? $fg[green](y):$reset_color "
    	read response
    	if [[ "$response" =~ ^[yY]?$ ]]; then
    		update
    	fi
    fi
fi
