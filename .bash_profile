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

# Updates WordPress plugins and commits each update in Git
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

# WP Engine SSH shortcut
function sshwpe() {
    if [ -z "$1" ]; then
        echo "Usage: sshwpe <install name>"
    else
        HOSTNAME="$1.ssh.wpengine.net"
        ssh $1@$HOSTNAME
    fi
}

# Generate dummy WordPress posts
function wp-generate-posts() {
    if ! $(wp core is-installed); then
        return 1
    fi

    if [ -z "$1" ]; then
        echo "Usage: wp-generate-posts <user id> <number of posts> <post type>. If post type is left blank, command defaults to 'post'."
        return 1
    fi

    # Set author ID to 2 unless first paramter was passed.
    AUTHOR=${1:-2}
    # Set number of posts at 10 unless second parameter was passed.
    NUM=${2:-10}
    # Set post type to 'post' unless third parameter was passed.
    POST_TYPE=${3:-post}

    # Get an FPO image.
    ATTACHMENT_ID=$(wp media import "https://via.placeholder.com/800x600.png?text=FPO" --title=FPO --alt="FPO Image" --porcelain)

    # Create the posts.
    for n in {1..$NUM}
    do
        # Get very short paragraph as title.
        TITLE_RAW=$(curl http://loripsum.net/api/1/plaintext/veryshort/prude/)
        # Snip off trailing period.
        TITLE=${TITLE_RAW%?}
        # Generate the post while passing in 6 paragraphs as the_content.
        POST_ID=$(curl "http://loripsum.net/api/6/prude/headers/decorate/link/ul/" | wp post generate --post_content --count=1 --post_type=$POST_TYPE --post_title=$TITLE --post_author=$AUTHOR --format=ids)
        # Attach the FPO featured image.
        wp post meta add $POST_ID _thumbnail_id $ATTACHMENT_ID
    done
}

# Generate dummy resources (using Vital post type)
function wp-generate-resources() {
    if ! $(wp core is-installed); then
        return 1
    fi

    if [ -z "$1" ]; then
        echo "Usage: wp-generate-resources <user id> <number of posts>"
        return 1
    fi

    # Set author ID to 2 unless first paramter was passed.
    AUTHOR=${1:-2}
    # Set number of posts at 10 unless second parameter was passed.
    NUM=${2:-10}

    # Get FPO images.
    HERO_IMAGE=$(wp media import "https://via.placeholder.com/300x400.png?text=FPO" --title=FPO --alt="FPO Image" --porcelain)
    HERO_BG=$(wp media import "https://via.placeholder.com/2000x700.png?text=FPO" --title=FPO --alt="FPO Image" --porcelain)

    # Create the posts.
    for n in {1..$NUM}
    do
        # Get very short titles.
        TITLE_RAW=$(curl http://loripsum.net/api/1/plaintext/veryshort/prude/)
        SUBTITLE_RAW=$(curl http://loripsum.net/api/1/plaintext/veryshort/prude/)

        # Generate some text.
        THE_CONTENT=$(curl "http://loripsum.net/api/6/prude/headers/decorate/link/ul/")

        # Snip off trailing periods.
        TITLE=${TITLE_RAW%?}
        SUBTITLE=${SUBTITLE_RAW%?}

        # Generate the post while passing in 6 paragraphs as the_content.
        POST_ID=$(wp post generate --count=1 --post_type=resource --post_title=$TITLE --post_author=$AUTHOR --format=ids)

        # Add meta options
        wp post meta add $POST_ID gated_resource "0"
        wp post meta add $POST_ID _gated_resource "field_cpt_resource_gated"
        wp post meta add $POST_ID hero_bg "$HERO_BG"
        wp post meta add $POST_ID _hero_bg "field_cpt_resource_hero_bg"
        wp post meta add $POST_ID hero_image "$HERO_IMAGE"
        wp post meta add $POST_ID _hero_image "field_cpt_resource_hero_image"
        wp post meta add $POST_ID hero_subtitle_pregate "$SUBTITLE"
        wp post meta add $POST_ID _hero_subtitle_pregate "field_cpt_resource_hero_subtitle_pregate"
        wp post meta add $POST_ID enable_share "1"
        wp post meta add $POST_ID _enable_share "field_cpt_resource_enable_share"
        wp post meta add $POST_ID the_content "$THE_CONTENT"
        wp post meta add $POST_ID _the_content "field_cpt_resource_content"
        wp post meta add $POST_ID gate_form "1"
        wp post meta add $POST_ID _gate_form "field_cpt_resource_gate_form"
        wp post meta add $POST_ID hero_subtitle "$SUBTITLE"
        wp post meta add $POST_ID _hero_subtitle "field_cpt_resource_gate_hero_subtitle"
        wp post meta add $POST_ID resource_file_type "url"
        wp post meta add $POST_ID _resource_file_type "field_cpt_resource_type"
        wp post meta add $POST_ID url "https://vtldesign.com/"
        wp post meta add $POST_ID _url "field_cpt_resource_url"

    done
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

# ###########
# macOS Only
# ###########

# Update NPM, Homebrew, and all packages
alias updateall="sudo npm cache clean -f; sudo npm install -g n; sudo n stable; sudo npm install npm -g; brew update; brew upgrade --all; brew cleanup;wp cli update;wp package update;apm upgrade;"
alias updategems="sudo gem update `gem list | cut -d ' ' -f 1`"
