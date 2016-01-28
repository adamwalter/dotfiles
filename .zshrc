export ZSH=/Users/Adam/.oh-my-zsh

ZSH_THEME="adam"

plugins=(common-aliases git extract colored-man dircycle sublime urltools pj zsh-git-prompt)

export PATH="/Applications/MAMP/bin/php/php5.5.18/bin:/Applications/MAMP/Library/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

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

alias myip="curl ipecho.net/plain;echo"

#######################################
# ALIASES
#######################################

alias edithosts="subl /private/etc/hosts"
alias copykey="pbcopy < ~/.ssh/id_rsa.pub"
alias edit="nano"
alias ll="ls -alh"
alias updateall="sudo npm cache clean -f; sudo npm install -g n; sudo n stable; sudo npm install npm -g; brew update; brew upgrade --all; brew cleanup;"

#######################################
# PLUGIN SETTINGS
#######################################

# pj
PROJECT_PATHS=(~/Sites ~/Dropbox/Github)

#######################################
# DEFAULT EDITOR
#######################################

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi