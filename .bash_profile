# ##############################################################################
#  UTILITIES
# ##############################################################################

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

#  DNS, MX, and IP Lookups
function dns () {
    if [ -z "$1" ]; then
        echo "Usage: dns <ip address>"
    else
        local url=$(echo "$1" | sed 's|\/\/||' | sed 's|\/||' | sed 's|:||' | sed 's|https||' | sed 's|http||' | sed 's|www.||')
        dig -t ANY $url
    fi
}

function mx () {
    if [ -z "$1" ]; then
        echo "Usage: mx <hostname>"
    else
        local url=$(echo "$1" | sed 's|\/\/||' | sed 's|\/||' | sed 's|:||' | sed 's|https||' | sed 's|http||' | sed 's|www.||')
        dig mx +short $url
    fi
}

function ip () {
    if [ -z "$1" ]; then
        echo "Usage: ip <ip address>"
    else
        curl ipinfo.io/$1
    fi
}

alias myip="curl ipecho.net/plain;echo"

# Extract any kind of archive
function extract () {
    if [ -z "$1" ]; then
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    else
        if [ -f $1 ] ; then
            case $1 in
              *.tar.bz2)   tar xvjf ../$1    ;;
              *.tar.gz)    tar xvzf ../$1    ;;
              *.tar.xz)    tar xvJf ../$1    ;;
              *.lzma)      unlzma ../$1      ;;
              *.bz2)       bunzip2 ../$1     ;;
              *.rar)       unrar x -ad ../$1 ;;
              *.gz)        gunzip ../$1      ;;
              *.tar)       tar xvf ../$1     ;;
              *.tbz2)      tar xvjf ../$1    ;;
              *.tgz)       tar xvzf ../$1    ;;
              *.zip)       unzip ../$1       ;;
              *.Z)         uncompress ../$1  ;;
              *.7z)        7z x ../$1        ;;
              *.xz)        unxz ../$1        ;;
              *.exe)       cabextract ../$1  ;;
              *)           echo "extract: '$1' - unknown archive method" ;;
            esac
        else
            echo "$1 - file does not exist"
        fi
    fi
}

# ##############################################################################
#  EXPORTS
# ##############################################################################

export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad
export GREP_OPTIONS='--color=auto'
export HISTFILESIZE=10000
export HISTSIZE=1000
export HISTCONTROL=ignoredups
export HISTIGNORE="clear:ls:exit:ll:cd:cd .."

# ##############################################################################
#  GIT PROMPT - https://github.com/magicmonty/bash-git-prompt
# ##############################################################################

# If installed from Github:
#source ~/.bash-git-prompt/gitprompt.sh

# If installed via Homebrew (Mac):
#if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
#    GIT_PROMPT_THEME_NAME="Adam"
#    source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
#fi

# ##############################################################################
#  COMMAND DEFAULTS
# ##############################################################################

alias c="clear"

# Do not delete / or prompt if deleting more than 3 files
alias rm="rm -I --preserve-root"

# Prompt before overwrite
alias mv="mv -i"
alias cp="cp -i"
alias ln="ln -i"

# List files
alias ls="ls --color=auto -Fab" # colorful ls
alias ll="ls --color=auto -lhA" # show hidden, long format, short unit suffix
alias lsl="ls --color=auto -Fab | less" # paginate results
alias lll="ls --color=auto -lhA | less" # paginate results (long list)
alias lss="ls --color=auto -lSr" # sort by size
alias lsp="stat -c '%A %a %G %U %n' *" # show full permission details

# Ping 10 times by default
alias ping="ping -c 10"

# Default editor
alias edit="nano -w -z"
alias nano="nano -w -z"

# Search history
alias histg="history | grep $1"

# Customize output of common utilities
alias df="df -Tha --total"
alias free="free -mt"
alias ps="ps auxf"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias pscpu="ps auxf | sort -nr -k 3 | head -10"
alias psmem="ps auxf | sort -nr -k 4 | head -10"
alias wget="wget -c"


# ##############################################################################
#  DIRECTORY BROWSING
# ##############################################################################

alias back="cd -"
alias ..="cd .."
alias cd..="cd .."

# Move up X directories
function up () {
    if [ -z "$1" ]; then
        echo "Usage: up <number of directories to move up>"
    else
        local x='';for i in $(seq ${1:-1});do x="$x../"; done;cd $x;
    fi
}

# ##############################################################################
#  GIT
# ##############################################################################

alias gita="git add"
alias gitp="git push"
alias gitl="git log"
alias gits="git status"
alias gitd="git diff"
alias gitc="git commit -m"
alias gitca="git commit -am"
alias gitb="git branch"
alias gitch="git checkout"
alias gitra="git remote add"
alias gitrr="git remote rm"
alias gitpl="git pull"
alias gitcl="git clone"

# ##############################################################################
#  ENVIRONMENT
# ##############################################################################

# Get distribution/OS
alias getos="grep -qs '' /etc/lsb-release && lsb_release -a | grep -v n/a | grep -v none; uname -rms"

# Get software version/info
function version () {
    if [ -z "$1" ]; then
        echo "Usage: version <apache|php|mysql>"
    else
        if [ $1 = "apache" ]; then
            httpd -V
        fi
        if [ $1 = "php" ]; then
            php -v
        fi
        if [ $1 = "mysql" ]; then
            mysql -V
        fi
    fi
}

# ##############################################################################
#  MISCELLANEOUS
# ##############################################################################

# Create random password
function newpass () {
    if [ -z "$1" ]; then
        echo "Usage: newpass <number of characters>"
    else
        cat /dev/urandom | strings | grep -o '[[:alnum:]]' | head -n $1 | tr -d '\n';echo
    fi
}

alias editbash="nano ~/.bash_profile"
alias sourcebash="source ~/.bash_profile"
alias editbashrc="nano /etc/bashrc"