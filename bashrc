# .bashrc
#
# Lots and lots of pieces were borrowed from Advanced Bash Scripting
# Guide and the rest of the Web.  Thanks to all who helped along the
# way.


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#######################################################
# Useful functions
#######################################################

# Set title of the xterm to given args
function xtitle () {

	case "$TERM" in
		*term | rxvt)
			echo -n -e "\033]0;$*\007" ;;
		*)
			;; 
	esac
}


# Find file that matches specified pattern
function ff() {

	find . -type f -iname '*'$*'*' -print | grep -v '.svn'

}

# If wide terminal window, show full path. Otherwise, just current dir
function get_pwd () {
	if [ "${COLUMNS}" -lt "70" ]
	then
		echo -n "./"
		basename `pwd`
	else
		pwd
	fi
}

# If wide terminal window, show full hostname. Otherwise, just host part.
# Alwasy remove .localdomain and .local bits
function get_hostname () {
	if [ "${COLUMNS}" -lt "70" ]
	then
		HOST=`hostname -s`
	else
		HOST=${HOSTNAME}
	fi

	echo $HOST | sed -e 's/.localdomain//' -e 's/.local//'
}

# Build prompt without polluting much of the namespace
function prompt () {

	# Backgrounds (there is ~/bin/colors somewhere):
	# 40 = black
	# 41 = red
	# 42 = green
	# 43 = brown
	# 44 = blue
	# 45 = magenta
	# 46 = cyan
	# 47 = light gray

	local CYAN="\[\033[44;1;36m\]"
	local MAGENTA="\[\033[44;1;35m\]"
	local BLUE="\[\033[44;34m\]"
	local YELLOW="\[\033[44;1;33m\]"
	local GREEN="\[\033[44;1;32m\]"
	local BLACK_ON_WHITE="\[\033[0m\]"

	case $TERM in
		xterm*|rxvt*)
			TITLEBAR='\[\033]0;\u@\H:\w\007\]'
			;;
		*)
			TITLEBAR=""
			;;
	esac

	PS1="${TITLEBAR}\n${CYAN}[\t][${MAGENTA}\u${CYAN}@${YELLOW}\$(get_hostname)${CYAN}:${GREEN}\$(get_pwd)${YELLOW}\$(__git_ps1 \" (%s)\")${CYAN}]${BLACK_ON_WHITE}\$ "
	PS2="${CYAN}[\t][$MAGENTA\u$CYAN@$YELLOW\$(get_hostname)${CYAN}:$GREEN\W$CYAN]${BLACK_ON_WHITE}> "
}

function welcome () {
	echo
	printf "Welcome to %s (%s %s %s)\n" "$(lsb_release -s -d)" "$(uname -o)" "$(uname -r)" "$(uname -m)"
	echo
	uptime
	echo
	df -h | grep -E -v "tmpfs|rootfs|devtmpfs"
	echo
}
#######################################################
# Export some useful variables
#######################################################
export PATH=$PATH:$HOME/bin
export PAGER=`which --skip-alias less 2> /dev/null`
export EDITOR=`which --skip-alias vim 2> /dev/null`
export SVN_EDITOR=$EDITOR
export LC_TIME=en_US
export HISTTIMEFORMAT=" (%F %T) "
export MOZ_NO_REMOTE=1

# Shorten and simplify cd
export CDPATH=.:~:~/Development:/var/www/html:/var/www/vhosts
# Do not save these commands to history
export HISTIGNORE="bg:fg:h:history"
# Ignore files matching this suffixes from completion
export FIGNORE=".svn"

#######################################################
# Aliases
#######################################################
alias vi="vim"
alias ll="ls -al"
alias df="df -kTh"
alias du="du -kh"
alias ..="cd .."
alias ...="cd .."
alias h="history"
alias p="phing"
alias traceroute="traceroute -I"
alias who="who -HT"

alias head='head -n $((${LINES:-12}-2))' #as many as possible without scrolling
alias tail='tail -n $((${LINES:-12}-2)) -s.1' #Likewise, also more responsive -f

# what most people want from od (hexdump)
alias hd='od -Ax -tx1z -v'

alias top="xtitle Processes on $HOSTNAME && top"
alias make="xtitle Making $(basename $PWD) ; make"
#######################################################
# Set some shell options
#######################################################
ulimit -S -c 0 			# No core dump files

set -o notify 			# Notify when jobs in background terminate
#set -o noclobber 		# Prevent overwriting files by rediction
#set -o nounset 		# Errors if using undefined variable
set -o vi 				# Vi-style command editing


shopt -s cdable_vars 	# directory to cd is in variable
shopt -s cdspell 		# correct minor spelling mistakes
shopt -s checkhash 		# check hash for the command,before path search
shopt -s checkwinsize 	# check window size after every command
shopt -s cmdhist 		# save multiline commands as one history item
shopt -s histappend histreedit histverify # better history management

shopt -u mailwarn
unset MAILCHECK

#######################################################
# Android SDK
#######################################################
PATH=$PATH:$HOME/lib/android-sdk-linux_x86:$HOME/android-sdk-linux_x86/tools
export PATH

# For SDK version r_08 and higher, also add this for adb:
# PATH=$PATH:$HOME/AndroidSDK/platform-tools
# export PATH

#######################################################
# Last bits
#######################################################

#
# Call prompt() which was defined above
#
prompt
welcome
