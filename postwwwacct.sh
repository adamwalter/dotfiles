#!/bin/bash

# Adds Bash Git Prompt to new cPanel users after creation

git clone https://github.com/magicmonty/bash-git-prompt.git /home/$USER/.bash-git-prompt --depth=1
curl "https://gitlab.com/adamwalter/dotfiles/raw/master/.git-prompt-colors.sh" -o /home/$USER/.git-prompt-colors.sh
echo "" >> /home/$USER/.bash_profile
echo "source ~/.bash-git-prompt/gitprompt.sh" >> /home/$USER/.bash_profile
