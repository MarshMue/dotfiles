#!/bin/bash

if [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
fi

export EDITOR=vim
export VISUAL=vim
export HISTTIMEFORMAT="%F %T "
export TERM=xterm-256color
build_prompt () {
	local reset_color="\[\e[0;0m\]"

	local user_color="\[\e[\$(user_prompt_color)m\]"
	local user_prompt="${user_color}\$(user_prompt_text)${reset_color}"

	local at_color="\[\e[38;5;209m\]"
	local at_prompt="${at_color}@${reset_color}"

	local dir_color="\[\e[38;5;168m\]"
	local dir_prompt="${dir_color}"$(dir_prompt_text)"${reset_color}"

	local git_color="\[\e[38;5;229m\]"
	local git_prompt="${git_color}\$(git_prompt_text)${reset_color}"

	local prompt_color="\[\e[\$(prompt_char_color)m\]"
	local prompt_prompt="${prompt_color}\$(prompt_char_text)${reset_color}"

	echo "${user_prompt}${at_prompt}${dir_prompt}${git_prompt}\$(vim_prompt_padding)${vim_prompt}${prompt_prompt} "
}

prompt_char_color () {
	if [ "$USER" == "root" ]; then
		printf "1;31"
	else
		printf "38;5;203"
	fi
}

prompt_char_text () {
	if [ "$USER" == "root" ]; then
		printf "#"
	else
		printf ">"
	fi
}

dir_prompt_text () {
	echo " \W "
}

user_prompt_color () {
	if [ "$USER" == "root" ]; then
		printf "1;31"
	else
		printf "38;5;204"
	fi
}

user_prompt_text () {
	echo "\$ $USER"
}

vim_prompt_padding () {
	if [ ! -z "$VIM" ]; then
		printf " "
	fi
}

dpwd_prompt_text () {
	if [ ! -z `declare -f -F dpwd` ]; then
		local dpwd=`dpwd`
		if [ ! -z "$dpwd" ]; then
			echo " ${dpwd}"
		fi
	fi
}

vim_prompt_text () {
	if [ ! -z "$VIM" ]; then
		printf "vim"
	fi
}

git_prompt_text () {
	if ! git rev-parse --git-dir > /dev/null 2>&1; then
		return 0
	fi

	local git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')

	echo " (${git_branch})"
}

export PS1=$(build_prompt)

alias vi="vim"

case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

export CLICOLOR=1

# export gopath
export GOPATH=$HOME/gopath
export PATH="$PATH:$GOPATH/bin"

source ~/.alias

