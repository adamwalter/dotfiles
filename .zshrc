export ZSH=/Users/vitaldesign/.oh-my-zsh

ZSH_THEME="custom"

plugins=(common-aliases extract colored-man)

export PATH="/usr/local/var/rbenv/shims:/Applications/MAMP/Library/bin:/Applications/MAMP/bin/php/php5.4.10/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin"

source $ZSH/oh-my-zsh.sh

source ~/.oh-my-zsh/custom/plugins/zsh-git-prompt/zshrc.sh

# ##############################################################################
#  DEFAULT EDITOR
# ##############################################################################

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi