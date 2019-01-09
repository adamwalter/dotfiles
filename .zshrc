export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="custom"

plugins=(common-aliases git extract colored-man dircycle urltools pj zsh-git-prompt)

export PATH="/Applications/MAMP/bin/php/php5.6.30/bin:$PATH"

source $ZSH/oh-my-zsh.sh
source "$ZSH/custom/plugins/zsh-git-prompt/zshrc.sh"
PROMPT='%{$FG[220]%}%c %{$reset_color%}$(git_super_status)%{$reset_color%} $ '
ZSH_GIT_PROMPT_SHOW_UPSTREAM=1

#######################################
# UTILITIES
#######################################

# Make directory then move into it
function mcd () {
    if [ -z "$1" ]; then
        echo "Usage: mcd <directory name>"
    else
        mkdir -p $1
        cd $1
    fi
}

# Find and delete foreign system files
function cleandir () {
    find . -name "*.DS_Store" -type f -delete -print
    find . -type d -name "__MACOSX" -print0 | xargs -rt0 rm -rv
    find . -type d -name ".AppleDouble" -print0 | xargs -rt0 rm -rv
}

# Create random password
function newpass () {
    if [ -z "$1" ]; then
        echo "Usage: newpass <number of characters>"
    else
        cat /dev/urandom | strings | grep -o '[[:alnum:]]' | head -n $1 | tr -d '\n';echo
    fi
}

# Move up X directories
function up () {
    if [ -z "$1" ]; then
        echo "Usage: up <number of directories to move up>"
    else
        local x='';for i in $(seq ${1:-1});do x="$x../"; done;cd $x;
    fi
}

#  DNS lookup
function dns () {
    if [ -z "$1" ]; then
        echo "Usage: dns <ip address>"
    else
        local url=$(echo "$1" | sed 's|\/\/||' | sed 's|\/||' | sed 's|:||' | sed 's|https||' | sed 's|http||' | sed 's|www.||')
        dig -t ANY $url
    fi
}

# MX lookup
function mx () {
    if [ -z "$1" ]; then
        echo "Usage: mx <hostname>"
    else
        local url=$(echo "$1" | sed 's|\/\/||' | sed 's|\/||' | sed 's|:||' | sed 's|https||' | sed 's|http||' | sed 's|www.||')
        dig mx +short $url
    fi
}

# IP location lookup
function ip () {
    if [ -z "$1" ]; then
        echo "Usage: ip <ip address>"
    else
        curl ipinfo.io/$1
    fi
}

# Hosting lookup
function lookup () {
    IP=`dig $1 +noall +answer +nocomments +short | tail -n 1`
    declare -A arr=();
    while read -r a b;
            do arr[$a]=$b;
    done < <(whois -h whois.arin.net $IP | grep -E "OrgName:|NetRange:|NetName:|Comment:|City:|StateProv:")
    echo -e "URL: $1\nIP: $IP\nOrganization: ${arr[OrgName:]}\nNet Name: ${arr[NetName:]}\nIP Range: ${arr[NetRange:]}\nLocation: ${arr[City:]}, ${arr[StateProv:]}"
}

# Get machine IP
alias myip="curl ipecho.net/plain;echo"

#######################################
# ALIASES
#######################################

# Default editor
alias nano="nano -w -z"
alias edit="code"

alias edithosts="edit /private/etc/hosts"
alias editssh="edit ~/.ssh/config"
alias editknown="edit ~/.ssh/known_hosts"
alias editbash="edit ~/.zshrc"
alias sourcebash="source ~/.zshrc"
alias copykey="pbcopy < ~/.ssh/id_rsa.pub"

# Ping 10 times by default
alias ping="ping -c 10"

# Update all the things
alias updateall="sudo npm cache clean -f; sudo npm install -g n; sudo n stable; sudo npm install npm -g; brew update; brew upgrade --all; brew cleanup;wp cli update;wp package update;apm upgrade;"
alias updategems="sudo gem update `gem list | cut -d ' ' -f 1`"

# WP-CLI
# Install plugin
alias wppi="wp plugin install --activate"
# Uninstall plugin
alias wppu="wp plugin uninstall --deactivate"

# WordPress
alias taildebug="clear;tail -f wp-content/debug.log;"
alias cleardebug=": > wp-content/debug.log"

#######################################
# PLUGIN SETTINGS
#######################################

# pj
PROJECT_PATHS=(~/Sites ~/Documents/Code)
