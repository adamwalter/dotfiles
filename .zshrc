#######################################
# SETUP
#
# 1. Install oh-my-zsh (via Homebrew)
# 2. Install plugins in ~/.oh-my-zsh/custom/plugins:
#     - https://github.com/sindresorhus/pure
#     - https://github.com/zsh-users/zsh-syntax-highlighting
#     - https://github.com/zsh-users/zsh-autosuggestions
#######################################

#######################################
# PATH
#######################################

# Use MAMP version of PHP & other PHP tuning
PHP_VERSION=`ls /Applications/MAMP/bin/php/ | sort -n | tail -2 | head -1`
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH=$PATH:/Applications/MAMP/bin/php/${PHP_VERSION}/bin
alias php='/Applications/MAMP/bin/php/${PHP_VERSION}/bin/php'

#######################################
# OH-MY-ZSH
#######################################

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# oh-my-zsh theme (Disabled as required by Pure prompt)
ZSH_THEME=""

# Auto-update behavior
zstyle ':omz:update' mode auto

# oh-my-zsh plugins
plugins=(colored-man-pages common-aliases extract git pj zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Pure prompt
# https://github.com/sindresorhus/pure
# Use manual install steps and clone to OMZ plugin dir
fpath+=($HOME/.oh-my-zsh/custom/plugins/pure)
autoload -U promptinit; promptinit
PURE_CMD_MAX_EXEC_TIME=60
zstyle :prompt:pure:git:stash show yes
prompt pure

# pj
PROJECT_PATHS=(~/Sites ~/Projects)

#######################################
# NVM
#######################################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#######################################
# Ruby / rbenv
#######################################

eval "$(rbenv init - zsh)"

#######################################
# UTILITY FUNCTIONS
#######################################

# Find and delete foreign system files
function cleandir () {
    find . -name "*.DS_Store" -type f -delete -print
    find . -type d -name "__MACOSX" -print0 | xargs -rt0 rm -rv
    find . -type d -name ".AppleDouble" -print0 | xargs -rt0 rm -rv
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

# IP location lookup
function ip () {
    if [ -z "$1" ]; then
        echo "Usage: ip <ip address>"
    else
        curl ipinfo.io/$1
    fi
}

# Make directory then move into it
function mcd () {
    if [ -z "$1" ]; then
        echo "Usage: mcd <directory name>"
    else
        mkdir -p $1
        cd $1
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

# Create random password
function newpass () {
    if [ -z "$1" ]; then
        echo "Usage: newpass <number of characters>"
    else
        cat /dev/urandom | strings | grep -o '[[:alnum:]]' | head -n $1 | tr -d '\n';echo
    fi
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

# Move up X directories
function up () {
    if [ -z "$1" ]; then
        echo "Usage: up <number of directories to move up>"
    else
        local x='';for i in $(seq ${1:-1});do x="$x../"; done;cd $x;
    fi
}

# Download WordPress plugin
function wp-download-plugin () {
    PLUGIN_DIR=$PWD/wp-content/plugins

    if [ -z "$1" ]; then
        echo "Usage: wp-download-plugin <plugin slug>"
    else
        if [ ! -d "$PLUGIN_DIR" ]; then
            echo "Directory $PLUGIN_DIR does not exist. Create it and run this command again."
        else
            curl -OL "https://downloads.wordpress.org/plugin/$1.latest-stable.zip"
            unzip "./$1.latest-stable.zip" -d $PLUGIN_DIR
        fi

        rm -f "./$1.latest-stable.zip"
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

#######################################
# ALIASES
#######################################

# Get machine IP
alias myip="curl ipecho.net/plain;echo"

# Default editor
alias nano="nano -w -z"
alias edit="code"

# Prompt before overwrite
alias mv="mv -i"
alias cp="cp -i"
alias ln="ln -i"

# List files
alias l.='ls -ld .*'

# Edit file shortcuts
alias edithosts="sudo code /private/etc/hosts"
alias editssh="edit ~/.ssh/config"
alias editknown="edit ~/.ssh/known_hosts"
alias editbash="edit ~/.zshrc"
alias reload="exec zsh"
alias copykey="pbcopy < ~/.ssh/id_rsa.pub"

# Search history
alias histg="history | grep $1"

# Ping 10 times by default
alias ping="ping -c 10"

# Update all the things
alias updateall="sudo npm cache clean -f; sudo npm install -g n; sudo n stable; sudo npm install npm -g; brew update; brew upgrade; brew cleanup;wp cli update;wp package update;"
alias updategems="sudo gem update `gem list | cut -d ' ' -f 1`"

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

# Version Control
alias svndiff='svn diff --diff-cmd colordiff -x "-u -w -p" "$@" | less -R'
