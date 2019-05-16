# Custom theme for Bash Git Prompt
# https://github.com/magicmonty/bash-git-prompt
override_git_prompt_colors() {
	local BoldOrange="$(tput bold)$(tput setaf 202)"
	local BoldLightGrey="$(tput bold)$(tput setaf 250)"
	local BoldYellow="$(tput bold)$(tput setaf 214)"
	local Green=$(tput setaf 70)
	local BoldGreen="$(tput bold)$(tput setaf 70)"
	GIT_PROMPT_THEME_NAME="Vital"
	GIT_PROMPT_PREFIX="("
	GIT_PROMPT_SUFFIX=")"
	GIT_PROMPT_START_USER="${BoldOrange}\u${BoldLightGrey}@${BoldYellow}\H${ResetColor}: ${Green}\w${ResetColor}"
	GIT_PROMPT_END_USER="\n$ "
	GIT_PROMPT_END_ROOT="\n# "
}

reload_git_prompt_colors "Vital"
