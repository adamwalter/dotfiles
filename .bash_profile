# Enable color output in macOS Terminal
export CLICOLOR=1

# History settings
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTIGNORE="clear:ls:exit:ll:cd:cd .."

# Set nano as default text editor
export EDITOR=nano
export VISUAL=nano
export SVN_EDITOR="$VISUAL"

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

# ##############################################################################
#  GIT PROMPT - https://github.com/magicmonty/bash-git-prompt
# ##############################################################################

# If installed from Github:
#source ~/.bash-git-prompt/gitprompt.sh

# If installed via Homebrew:
#if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
#  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
#  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
#fi

# Theme name
#GIT_PROMPT_THEME="Custom"

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

# Updates all WordPress plugins and commits them individually in Git
function wp-update-plugins() {
	UPDATES=`wp plugin list --update=available --fields=name,title,update_version --format=csv`
	i=1

	while IFS="," read -r slug name version
	do
		# Output from `wp plugin list` includes headers - this will skip them
		test $i -eq 1 && ((i=i+1)) && continue

		echo "Updating $name to $version..."

		wp plugin update $slug &&
		    git add -A wp-content/plugins/$slug &&
		    git commit -m "Updates $name to $version"
	done <<< "$UPDATES"

    if $(wp cli has-command wc) ; then
        echo 'Updating WooCommerce data...';
        wp wc update
    fi
}

# Updates WordPress core and commits the update in Git
function wp-update-core() {

    if ! [[ -z $(git status -s) ]]; then
        echo "Your Git repo is dirty. Commit or stash your current changes and run this command again."
        return 0
    fi

	echo "Checking WordPress version..."
	update=$(wp core check-update --field=version --format=count --allow-root)
	if [[ -z $update ]]; then
        CURRENT=`wp core version`
		echo "WordPress is at the latest version ($CURRENT)"
		return 0
	fi

	echo "Updating WordPress..."
    PREVIOUS=`wp core version`
    wp core update
    wp core update-db

	echo "Committing update in Git..."
    UPDATED=`wp core version`
    git add --all
    git commit -m "Updates WordPress from $PREVIOUS to $UPDATED"
}

# WP Engine SSH shortcut
function sshwpe() {
    if [ -z "$1" ]; then
        echo "Usage: sshwpe <install name>"
    else
        HOSTNAME="$1.ssh.wpengine.net"
        ssh $1@$HOSTNAME
    fi
}

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
alias l.='ls -ld .*'
alias ll='ls -l --color=auto'
alias lr='ls -tRFh'
alias lrt='ls -1Fcrt'
alias ls='ls -G'
alias lsa='ls -lah'
alias lt='ls -ltFh'
alias lsp="stat -c '%A %a %G %U %n' *" # show full permission details

# grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# Ping 10 times by default
alias ping="ping -c 10"

# Default editor
alias nano="nano -w -z"
alias edit="nano -w -z"

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

# Edit files
alias edithosts="edit /private/etc/hosts"
alias editssh="nano ~/.ssh/config"
alias editknown="nano ~/.ssh/known_hosts"
alias copykey="cat ~/.ssh/id_rsa.pub"
alias editbash="nano ~/.bash_profile"
alias sourcebash="source ~/.bash_profile"

# WP-CLI
# Install plugin
alias wppi="wp plugin install --activate"
# Uninstall plugin
alias wppu="wp plugin uninstall --deactivate"

# WordPress & Development
alias taildebug="clear;tail -f wp-content/debug.log;"
alias cleardebug=": > wp-content/debug.log"
alias json2php='php -r '"'"'echo var_export(json_decode(file_get_contents($argv[1]), true));'"'"''
alias svgowxml="svgo --disable=removeXMLProcInst"

# Find available updates for WordPress plugins via WP-CLI, then upgrade theme one at a time.
# After each upgrade, commit the changed files to Git.
#
# Requires that WP-CLI be installed and in your path: http://wp-cli.org/
#
# Currently, it will only work when run from the root of the WordPress installation, and has
# a hard-coded path for wp-content/plugins.
function wp-update-plugins () {
        UPDATES=`wp plugin list --update=available --fields=name,title,update_version --format=csv`
        i=1

        while IFS="," read -r slug name version
        do
                # Output from `wp plugin list` includes headers - this will skip them
                test $i -eq 1 && ((i=i+1)) && continue

                echo "Updating $name to $version..."

                wp plugin update $slug &&
                    git add -A wp-content/plugins/$slug &&
                    git commit -m "Updates $name to $version"
        done <<< "$UPDATES"

    if $(wp cli has-command wc) ; then
        echo 'Updating WooCommerce data�^��';
        wp wc update
    fi
}

# ###########
# macOS Only
# ###########

# Update NPM, Homebrew, and all packages
alias updateall="sudo npm cache clean -f; sudo npm install -g n; sudo n stable; sudo npm install npm -g; brew update; brew upgrade --all; brew cleanup;wp cli update;wp package update;apm upgrade;"
alias updategems="sudo gem update `gem list | cut -d ' ' -f 1`"
