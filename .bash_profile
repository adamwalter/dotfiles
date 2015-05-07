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

alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch -a'
alias gbr='git branch --remote'
alias gc='git commit -v'
alias 'gc!'='git commit -v --amend'
alias gca='git commit -v -a'
alias 'gca!'='git commit -v -a --amend'
alias gcl='git config --list'
alias gclean='git reset --hard && git clean -dfx'
alias gcm='git checkout master'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcs='git commit -S'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdt='git difftool'
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
alias ggpull='git pull origin $(current_branch)'
alias ggpur='git pull --rebase origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
alias gk='gitk --all --branches'
alias gl='git pull'
alias glg='git log --stat --max-count=10'
alias glgg='git log --graph --max-count=10'
alias glgga='git log --graph --decorate --all'
alias glo='git log --oneline --decorate --color'
alias globurl='noglob urlglobber '
alias glog='git log --oneline --decorate --color --graph'
alias glp=_git_log_prettily
alias gm='git merge'
alias gmt='git mergetool --no-prompt'
alias gp='git push'
alias gpoat='git push origin --all && git push origin --tags'
alias gr='git remote'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grep='grep --color'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias grup='git remote update'
alias grv='git remote -v'
alias gsd='git svn dcommit'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash'
alias gstd='git stash drop'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gts='git tag -s'
alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gvt='git verify-tag'
alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git ls-files --deleted -z | xargs -r0 git rm; git commit -m "--wip--"'

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