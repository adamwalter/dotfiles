# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

# Bash Git Prompt
# https://github.com/magicmonty/bash-git-prompt
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    source $HOME/.bash-git-prompt/gitprompt.sh
fi
