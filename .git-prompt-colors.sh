# This is the custom theme template for gitprompt.sh

# These are the defaults from the "Default" theme
# You just need to override what you want to have changed
override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom"

  # Custom Colors
  local Orange="\[\e[38;5;202m\]"
  local Yellow="\[\e[38;5;220m\]"

  # Custom variables
  local User="\u"
  local Host="\H"
  local DirBase="\W"

  ## These are the color definitions used by gitprompt.sh
  GIT_PROMPT_PREFIX="("                 # start of the git info string
  GIT_PROMPT_SUFFIX=")"                 # the end of the git info string
  #GIT_PROMPT_SEPARATOR="|"              # separates each item

  # GIT_PROMPT_BRANCH="${Magenta}"        # the git branch that is active in the current directory
  # GIT_PROMPT_STAGED="${Reds}●"           # the number of staged files/directories
  # GIT_PROMPT_CONFLICTS="${Red}✖ "       # the number of files in conflict
  # GIT_PROMPT_CHANGED="${Blue}✚ "        # the number of changed files

  # GIT_PROMPT_REMOTE=" "                 # the remote branch name (if any) and the symbols for ahead and behind
  GIT_PROMPT_UNTRACKED="${Green}…"       # the number of untracked files/dirs
  # GIT_PROMPT_STASHED="${BoldBlue}⚑ "    # the number of stashed files/dir
  # GIT_PROMPT_CLEAN="${BoldGreen}✔"      # a colored flag indicating a "clean" repo

  ## For the command indicator, the placeholder _LAST_COMMAND_STATE_
  ## will be replaced with the exit code of the last command
  ## e.g.
  ## GIT_PROMPT_COMMAND_OK="${Green}✔-_LAST_COMMAND_STATE_ "    # indicator if the last command returned with an exit code of 0
  ## GIT_PROMPT_COMMAND_FAIL="${Red}✘-_LAST_COMMAND_STATE_ "    # indicator if the last command returned with an exit code of other than 0

  GIT_PROMPT_COMMAND_OK="${Green}✔${ResetColor}"    # indicator if the last command returned with an exit code of 0
  GIT_PROMPT_COMMAND_FAIL="${Red}✘-_LAST_COMMAND_STATE_"    # indicator if the last command returned with an exit code of other than 0

  ## template for displaying the current virtual environment
  ## use the placeholder _VIRTUALENV_ will be replaced with
  ## the name of the current virtual environment (currently CONDA and VIRTUAL_ENV)
  # GIT_PROMPT_VIRTUALENV="(${Blue}_VIRTUALENV_${ResetColor}) "

  ## _LAST_COMMAND_INDICATOR_ will be replaced by the appropriate GIT_PROMPT_COMMAND_OK OR GIT_PROMPT_COMMAND_FAIL
  GIT_PROMPT_START_USER="\n${Orange}${User}@${Host}${ResetColor}: ${Yellow}${DirBase}${ResetColor}"
  # GIT_PROMPT_START_ROOT="_LAST_COMMAND_INDICATOR_ ${GIT_PROMPT_START_USER}"
  GIT_PROMPT_END_USER=" \n$ "
  GIT_PROMPT_END_ROOT=" \n# "

  ## Please do not add colors to these symbols
  # GIT_PROMPT_SYMBOLS_AHEAD="↑·"             # The symbol for "n versions ahead of origin"
  # GIT_PROMPT_SYMBOLS_BEHIND="↓·"            # The symbol for "n versions behind of origin"
  # GIT_PROMPT_SYMBOLS_PREHASH=":"            # Written before hash of commit, if no name could be found
  # GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="L" # This symbol is written after the branch, if the branch is not tracked
}

reload_git_prompt_colors "Custom"