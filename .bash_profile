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

# Create random password
function newpass () {
    if [ -z "$1" ]; then
        echo "Usage: newpass <number of characters>"
    else
        cat /dev/urandom | strings | grep -o '[[:alnum:]]' | head -n $1 | tr -d '\n';echo
    fi
}

# Move up to a certain directory
# https://github.com/driv/upto
function upto() {
	local EXPRESSION="$1"
	if [ -z "$EXPRESSION" ]; then
		echo "A folder expression must be provided." >&2
		return 1
	fi
	if [ "$EXPRESSION" = "/" ]; then
		cd "/"
		return 0
	fi
	local CURRENT_FOLDER="$(pwd)"
	local MATCHED_DIR=""
	local MATCHING=true

	while [ "$MATCHING" = true ]; do
		if [[ "$CURRENT_FOLDER" =~ "$EXPRESSION" ]]; then
			MATCHED_DIR="$CURRENT_FOLDER"
			CURRENT_FOLDER=$(dirname "$CURRENT_FOLDER")
		else
			MATCHING=false
		fi
	done
	if [ -n "$MATCHED_DIR" ]; then
		cd "$MATCHED_DIR"
		return 0
	else
		echo "No Match." >&2
		return 1
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
source ~/.bash-git-prompt/gitprompt.sh
GIT_PROMPT_THEME_NAME="Custom"

# ##############################################################################
#  COMMAND DEFAULTS
# ##############################################################################

alias c="clear"

# Prompt before overwrite
alias mv="mv -i"
alias cp="cp -i"
alias ln="ln -i"

# List files
alias l='ls -lFh'
alias lS='ls -1FSsh'
alias la='ls -lAFh'
alias lart='ls -1Fcart'
alias ldot='ls -ld .*'
alias ll='ls -l'
alias lr='ls -tRFh'
alias lrt='ls -1Fcrt'
alias ls='ls -G'
alias lsa='ls -lah'
alias lt='ls -ltFh'
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

# Get machine IP
alias myip="curl ipecho.net/plain;echo"

# Common files
alias editssh="nano ~/.ssh/config"
alias editknown="nano ~/.ssh/known_hosts"
alias copykey="cat ~/.ssh/id_rsa.pub"
alias editbash="nano ~/.bash_profile"
alias sourcebash="source ~/.bash_profile"
