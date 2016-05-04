export ZSH=/Users/Adam/.oh-my-zsh

ZSH_THEME="custom"

plugins=(common-aliases git extract colored-man dircycle urltools pj zsh-git-prompt)

export PATH="/Applications/MAMP/bin/php/php5.6.10/bin:/Applications/MAMP/Library/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/custom/plugins/zsh-git-prompt/zshrc.sh

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

# Get machine IP
alias myip="curl ipecho.net/plain;echo"

#######################################
# ALIASES
#######################################

alias c="clear"
alias ll="ls -alh"
alias edit="subl"
alias edithosts="subl /private/etc/hosts"
alias editssh="subl ~/.ssh/config"
alias editknown="subl ~/.ssh/known_hosts"
alias editbash="subl ~/.zshrc"
alias sourcebash="source ~/.zshrc"
alias copykey="pbcopy < ~/.ssh/id_rsa.pub"

# Ping 10 times by default
alias ping="ping -c 10"

# Update NPM, Homebrew, and all packages
alias updateall="sudo npm cache clean -f; sudo npm install -g n; sudo n stable; sudo npm install npm -g; brew update; brew upgrade --all; brew cleanup;wp cli update;"

#######################################
# PLUGIN SETTINGS
#######################################

# pj
PROJECT_PATHS=(~/Sites ~/Dropbox/Github)
