. $HOME/.private.sh

[[ $(uname) == "Darwin" ]] && mac=true
[[ $(uname) == "Linux"  ]] && linux=true

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.bin:$HOME/.local/bin
GOPATH=/usr/local/go
if [[ $mac == true ]]; then
    PATH=$PATH:$HOME/.local/homebrew/bin
    PATH=$PATH:$HOME/Library/Python/3.6/bin
    PATH=$PATH:/usr/local/texlive/2018/bin/x86_64-darwin
    PATH=$PATH:$HOME/.rvm/bin
    PATH=$PATH:$HOME/.rvm/gems/ruby-2.4.4/bin
    PATH=$PATH:$HOME/Library/Python/3.7/bin
    GOPATH=$HOME/.local/go
elif [[ $linux == true ]]; then
    PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin
fi

PATH=$PATH:$GOPATH/bin
export PATH
export GOPATH

# Account for multiple versions of Java being installed for envy
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

unset PROMPT_COMMAND

# Instantly append commands to history
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

export EDITOR=vim

umask 002

function dir_prompt {
    if [[ -d .git ]] || git rev-parse --git-dir &>/dev/null; then
        printf "\[\e[34;4m\]"
        printf "\W"
        branch=$(git symbolic-ref --short HEAD)

        if ! [[ $branch == "master" ]]; then # TODO: Support default branches not named master
            printf "\[\e[0;90m\]:$branch"
        fi
        printf "\[\e[0m\]"
        if ! [[ -z $(git status --porcelain) ]]; then
            printf " \[\e[33m\]△\[\e[0m\]"
        fi
    else
        printf "\[\e[34m\]\W\[\e[0m\]"
    fi
}
char="_"
if [[ $mac == true ]]; then
    char=">"
elif [[ $linux == true ]]; then
    char="$"
    #char="∑"
fi
function status_prompt {
    if [[ $1 -eq 0 ]]; then
        printf "\[\e[32m\]"
    else
        printf "\[\e[31m\]"
    fi
    printf "$char\[\e[0m\]"
}
function chpwd {
    PS1="$(dir_prompt) $(status_prompt $1) "
}
PROMPT_COMMAND="chpwd \$?;$PROMPT_COMMAND"

if [[ $mac == true ]]; then
    alias ls='ls -G'
    alias l='ls -Glah'

    alias slp='pmset sleepnow'
    alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
    # Preview images
    function eog {
        (qlmanage -p $@ &>/dev/null &)
    }

    function vup   { ssh mir -T "pamixer --increase $1"; }
    function vdown { ssh mir -T "pamixer --decrease $1"; }

    eval $(minikube docker-env)
elif [[ $linux == true ]]; then
    alias ls='ls --color=auto'
    alias l='ls -lah --color=auto'
    alias torrent='transmission-cli'
    function wallpaper {
        gsettings set org.gnome.desktop.background picture-uri file://"$(realpath "$1")"
    }
    function lockscreen {
        gsettings set org.gnome.desktop.screensaver picture-uri file://"$(realpath "$1")"
    }
    alias suspend='systemctl suspend'
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    alias vup='pamixer --increase'
    alias vdown='pamixer --decrease'
fi

function espera {
    chars="-\\|/"
    tries=0
    while ! ping -t 1 -c 1 -n "$1" &> /dev/null; do
        ((tries++))
        printf "\r\e[0m$1 \e[32m${chars:$((tries%4)):1}"
        sleep 0.2
    done
    printf "\r"
}
function essh {
    # Espera hasta que esté listo pa conectarse
    # TODO: Strip username and/or read from SSH config
    espera "$1" && ssh "$1"
}

alias git='hub'
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gst='git status -s' # Standard ZSH alias doesn't use -s
alias gs='git status -s' # Account for missing t key
alias gd='git diff'
alias glo='git log --oneline --decorate'
alias gsta='git stash save'
alias gstp='git stash pop'

alias texclean='rm -fv *.{aux,bbl,blg,log,out,pdf,synctex.gz,pyg,fls,fdb_latexmk,dvi}'
# I will eventually memorize this and remove it.
alias fix_perms='echo "chmod -R u=rwX,go=rX"'
alias sl='ls'
function gorm {
    rm -rf $GOPATH/{pkg/*/*/*/$1.*,src/*/*/$1} 2>/dev/null
}

function pgc {
    git commit -m "$(git diff --cached --name-only): $2"
}

function cgc {
    git commit -m "$1($2): $3 $(git rev-parse --abbrev-ref HEAD)"
}

alias r='. ~/.bashrc'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Seamus' functions
envy_mysql_port() {
  local port="$(kubectl get service | grep percona | awk '{print $5}' | cut -c 6-10)"
  echo $port;
}

mysql_envy() {
  local port="$(envy_mysql_port)"
  mysql -h localenv.ninja --port $port -u schoologydev --password="schoologydev" --database schoology
}


mysql_client_path() {
  echo $(which mysql)
}

envy_db_dump() {
  local dump="$(mysql_client_path)"
  local port="$(envy_mysql_port)"
  mkdir -p ~/tmp/db_snapshots
  $dump -h localenv.ninja -u schoologydev --password="schoologydev" --port $port \
    --database schoology schoology_acl schoology_assessment schoology_cache \
      schoology_common_assessment_submissions schoology_common_assessments \
      schoology_course_completion schoology_media_files schoology_messaging_acl schoology_oauth schoology_part_1 scorm_engine \
     > ~/tmp/db_snapshots/mysqldump_dev.sql && gzip -f ~/tmp/db_snapshots/mysqldump_dev.sql
}

envy_db_restore() {
  local mysql="$(which mysql)"
  local port="$(kubectl get service | grep percona | awk '{print $5}' | cut -c 6-10)"
  gunzip -c ~/tmp/db_snapshots/mysqldump_dev.sql.gz | $mysql -h localenv.ninja -u schoologydev --password="schoologydev" --port $port
}


alias envy-fix-date='minikube ssh -- sudo date -u $(date -u +%m%d%H%M%Y.%S)'

pen() {
  pods=( $(gp | grep "$1" | awk '{print $1}') )
  echo Entering "${pods[0]}"
  kubectl exec -it "${pods[0]}" sh
}

migrate() {
  pods=( $(gp | grep "sgy-web" | awk '{print $1}') )
  echo migrating for "${pods[0]}"
  kubectl exec "${pods[0]}" -- bash -c "cd /var/www/html/schoology/docroot/ && sh .curio/migrate.sh"
}

search() {
  pods=( $(gp | grep "web" | awk '{print $1}') )
  echo Reindexing search for "${pods[0]}"
  kubectl exec "${pods[0]}" -- bash -c "cd /var/www/html/schoology/docroot/scripts/search && php-cgi es-reindex.php"
}

k-bootstrap-selenium() {
  cde && helm del --purge selenium &>/dev/null && helm install --name selenium -f envy_values.yaml systems/selenium/helm/selenium &>/dev/null &&
  nohup kubectl port-forward $(kubectl get pods -l app=selenium-node -o jsonpath='{ .items[0].metadata.name }') 5901:5900 &>/dev/null & echo 'port-forwarding' &&
  # get web pod
  pods=( $(gp | grep "web" | awk '{print $1}') )
  echo entering "${pods[0]} and running @testing"
  kubectl exec "${pods[0]}" -- bash -c "cd /var/www/html/schoology/docroot/ && ./scripts/run-automation-suite.php run -c  bdd.yml bdd -g testing --env envy --debug"
}

alias k-start-cassandra='kubectl scale statefulsets envy-base-cassandra --replicas=1'
alias k-stop-cassandra='kubectl scale statefulsets envy-base-cassandra --replicas=0'

alias k-stop-selenium='kubectl scale deploy selenium --replicas=0 && kubectl scale deploy selenium-node --replicas=0'
alias k-stop-scoreable='kubectl scale deploy schoology-scoreable-service --replicas=0 && kubectl scale deploy selenium-node --replicas=0'

# k-stop-events-pipeline() {
#   deployments=( $(gd | grep "eventspipeline" | awk '{print $1}') )
#   for deployment in "${deployments[@]}"
#   do
#     echo "removing deployment ${deployment}"
#     kubectl scale deploy "${deployment}" --replicas=0
#   done;
# }

k-stop-fuzzy() {
  deployments=( $(kubectl get deployments | grep "$1" | awk '{print $1}') )
  for deployment in "${deployments[@]}"
  do
    echo "seamus says: removing deployment ${deployment}"
    kubectl scale deploy "${deployment}" --replicas=0
  done;
}

k-start-fuzzy() {
  deployments=( $(kubectl get deployments | grep "$1" | awk '{print $1}') )
  for deployment in "${deployments[@]}"
  do
    echo "adding deployment ${deployment}"
    kubectl scale deploy "${deployment}" --replicas=1
  done;
}

# schema()
# {
#   pods=( $(gp | grep "web" | awk '{print $1}') )
#   echo running schema updates via for "${pods[0]}"
#   cds && kubectl exec "${pods[0]}" -- bash -c 'php-cgi /var/www/html/schoology/docroot/updates_auto.php updates_tests=1 cli_key=MUWSvxf9RurT3sdAuktLPeww'
# }

plog-web() {
  pods=( $(gp | grep "sgy-web" | awk '{print $1}') )
  cde && kubectl exec "${pods[0]}" -- bash -c 'tail -n 50 -f /var/log/schoology/watchdog.log'
}

plog() {
  pods=( $(gp | grep "$1" | awk '{print $1}') )
  cde && kubectl log "${pods[0]}" -f --tail=100
}

podrm() {
 pods=( $(kubectl get pods | grep "$1" | awk '{print $1}') )
 for pod in "${pods[@]}"
 do
   echo "removing pod ${pod}"
   kubectl delete pod "${pod}"
 done;
}


#DB BACKUP/RESTORE
envy_mysql_port() {
  local port="$(kubectl get service | grep percona | awk '{print $5}' | cut -c 6-10)"
  echo $port;
}

mysql_envy() {
  local port="$(envy_mysql_port)"
  mysql -h localenv.ninja --port $port -u schoologydev --password="schoologydev" --database schoology
}


mysql_client_path() {
  echo $(which mysql)
}

envy_db_dump() {
  local dump="$(mysql_client_path)"
  local port="$(envy_mysql_port)"
  mkdir -p ~/tmp/db_snapshots
  $dump -h localenv.ninja -u schoologydev --password="schoologydev" --port $port \
    --database schoology schoology_acl schoology_assessment schoology_cache \
      schoology_common_assessment_submissions schoology_common_assessments \
      schoology_course_completion schoology_media_files schoology_messaging_acl schoology_oauth schoology_part_1 scorm_engine \
     > ~/tmp/db_snapshots/mysqldump_dev.sql && gzip -f ~/tmp/db_snapshots/mysqldump_dev.sql
}

envy_db_restore() {
  local mysql="$(which mysql)"
  local port="$(kubectl get service | grep percona | awk '{print $5}' | cut -c 6-10)"
  gunzip -c ~/tmp/db_snapshots/mysqldump_dev.sql.gz | $mysql -h localenv.ninja -u schoologydev --password="schoologydev" --port $port
}

alias scho="cd $HOME/envy/systems/schoology/lib/sgy-shared/src/sgy-core/schoology"
export NODE_ENV=dev
export SCHOOLOGY_API_BASE="https://api.localenv.ninja/v1"
export ENVY_ROOT="$HOME/envy"
. ~/.aws_functions.sh

alias dist='rm -rf dist && python3 setup.py sdist && ~/Library/Python/3.7/bin/twine upload dist/*'

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/eboesen/mastery/node_modules/tabtab/.completions/serverless.bash ] && . /Users/eboesen/mastery/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/eboesen/mastery/node_modules/tabtab/.completions/sls.bash ] && . /Users/eboesen/mastery/node_modules/tabtab/.completions/sls.bash

# Scale deployment or statefulset up or down
# Example usage: k-scale cassandra 0
k-scale() {
  ss=( $(kubectl get statefulset | grep "$1" | awk '{print $1}') )
  for dep in "${ss[@]}"
  do
    kubectl scale statefulset "$dep" --replicas="$2"
  done;

  deployments=( $(kubectl get deployments | grep "$1" | awk '{print $1}') )
  for dep in "${deployments[@]}"
  do
    kubectl scale deployment "$dep" --replicas="$2"
  done;
}

# Scale Envy down to essential pods that serves Sgy site
k-scale-down-to-essential-pods() {
  k-scale cassandra 0;
  k-scale pipeline 0;
  k-scale files 0;
  k-scale portfolio 0;
  k-scale solr 0;
  k-scale mongo 0;
  k-scale elasticsearch 0;
  k-scale attributes 0;
  k-scale scorm 0;
}
