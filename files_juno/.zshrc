export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin
export GOPATH=/usr/local/go

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="erkbsn"
plugins=(git zsh-syntax-highlighting)

. $ZSH/oh-my-zsh.sh

alias torrent="transmission-cli"
alias http="sudo python3 -m http.server 80"

alias update="tmux new-session -s updates bash -c 'sudo zypper update -y && rm ~/.update' >/dev/null"
alias leoupd="cd ~/leopard;git pull;zip -r ~/www/leopard.zip ."

printf '\r\n'
echo "  $fg[cyan]J$fg[green] U$fg[yellow] N$fg[red] O 🚀$reset_color"
echo "  $fg[blue]$(uptime | awk '{print $3 "d " substr($5, 1, length($5)-1)}').$reset_color"

new_nodes=$(sed -n '/INCOMING/,$p' ~/ips)

if [ $(printf "$new_nodes\n" | wc -l) -gt 1 ]; then
	echo $fg[yellow]$new_nodes$reset_color
	echo
fi

if [ -e $HOME/.update ]; then
	printf "Check for updates? $fg[green](y):$reset_color "
	read response
	if [[ "$response" =~ ^[yY]?$ ]]; then
		update
	fi
fi
