export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:/home/erik/.gem/ruby/2.4.0/bin

export GOPATH=/usr/local/go

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="erkbsn"
plugins=(git)
. $ZSH/oh-my-zsh.sh

umask 077

alias update="tmux new-session -s updates bash -c 'sudo pacman -Syu --noconfirm && rm ~/.update' >/dev/null"
alias suspend="systemctl suspend"

alias pbcopy="xsel --clipboard --input"
alias pbpaste="xsel --clipboard --output"
alias vup="pamixer --increase"
alias vdown="pamixer --decrease"

alias torrent="transmission-cli"
alias st="ssh juno -t 'tmux a'"

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
