#============================================================================#
# zsh confuguration
# Created by Konstantin Shulgin <konstantin.shulgin@gmail.com>
#============================================================================#


#----------------------------------------------------------------------------#
# utily functions
#----------------------------------------------------------------------------#

# check is application exists via 'witch' utility
function provided_in_env()
{
    local bin=$1

    if which $bin > /dev/null 2>&1; then
	return 0
    fi

    return 1
}


#----------------------------------------------------------------------------#
# User enviroment settings
#----------------------------------------------------------------------------#

# zsh home directory
export ZSH_HOME=$HOME/.zsh

# Editor
export EDITOR=vim

# Path (add macports)
export PATH=$PATH:/opt/local/bin:/opt/local/sbin

# Man path (add macports)
export MANPATH=/opt/local/share/man:$MANPATH

# Set terminal type
export TERM=xterm-color

# Enable color in the terminal
export CLICOLOR=1


#-----------------------------------------------------------------------------#
# zsh mudules
#-----------------------------------------------------------------------------#

# Initialize colors
autoload -U colors; colors

# Initialize compinit
autoload -U compinit; compinit

#----------------------------------------------------------------------------#
# include completion
#----------------------------------------------------------------------------#
. ~/.zsh/completion

#-----------------------------------------------------------------------------#
# Load plugins and settings
#-----------------------------------------------------------------------------#

#
# Plugins loader
#

# load plugin from directory
function zsh_plugin_load()
{
    local plugin_dir=$1

    if [ ! -d $plugin_dir ];
    then
	return 1
    fi

    for ext in 'zsh' 'bash' 'sh'
    do
	local plugin_source=$plugin_dir/$(basename $plugin_dir).$ext
	if [ -e $plugin_source ]
	then
	    source $plugin_source
	    return 0
	fi
    done

    echo "$plugin_dir's soruce not found"
    return 1
}

# load all plugins from directory
function zsh_plugin_dir_load()
{
    local plugins_dir=$1
    if [ ! -d $plugins_dir ]; then
	echo "'$plugins_dir' isn't directory";
	return 1
    fi

    if [ ! "$(ls -A $plugins_dir)" ];
    then
	echo "'$plugins_dir' is empty"
	return 1
    fi

    for plugin in $plugins_dir/*
    do
	zsh_plugin_load $plugin
    done
}

# load all plugins
zsh_plugin_dir_load $ZSH_HOME/plugins


#
# Git plugin settings
#

# show dirty state in the branch
export GIT_PS1_SHOWDIRTYSTATE=true


#----------------------------------------------------------------------------#
# prompt settings
#----------------------------------------------------------------------------#

# Allow for functions in the prompt.
setopt PROMPT_SUBST

# Promt settings
PROMPT='%F{yellow}%n@%m%f:%F{cyan}%~%F{magenta}$(__git_ps1 "(%s)")%F{green}$%f '


#----------------------------------------------------------------------------#
# Colors
#----------------------------------------------------------------------------#

local dircolors_bin=""
for itr in 'dircolors' 'gdircolors'
do
    if (provided_in_env $itr); then
	dircolors_bin=$itr
	break
    fi
done

if [[ "$dircolors_bin" != "" ]]; then
    eval $($dircolors_bin ~/.zsh/dir_colors)
fi


#----------------------------------------------------------------------------#
# Aliases
#----------------------------------------------------------------------------#

local platform=`uname`
if [[ "$platform" == "Linux" ]]; then
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
else if [[ "$platform" == "Darwin" ]]
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    if (provided_in_env 'gls'); then
        # gls provids by coreutils from macports
	alias ls='gls --color=auto'
    else
	# gls doesn't exists, use BSD version
	alias ls='ls -G'
    fi

    if (provided_in_env 'gdir'); then
        # gls provids by coreutils from macports
	alias dir='gdir --color=auto'
    fi
fi

# lists
alias l='ls -CF'
alias la='ls -AL'
alias ll='ls -lF'

# move-rename w/o correction and always in interactive mode
alias mv='nocorrect mv -i'
# recursize copy w/o correction and always in interactive mode
alias cp='nocorrect cp -iR'
# remove w/o correction and always in interactive mode
alias rm='nocorrect rm -i'
# create direcotory w/o correction
alias mkdir='nocorrect mkdir'


#----------------------------------------------------------------------------#
# History
#----------------------------------------------------------------------------#

# History file
HISTFILE=$ZSH_HOME/zsh_history

# Commands count histroy in history file
SAVEHIST=5000

# Commands count histroy in one seance
HISTSIZE=5000

# Append history list to the history file (important for multiple parallel zsh sessions!)
setopt  APPEND_HISTORY

setopt  HIST_IGNORE_ALL_DUPS

setopt  HIST_IGNORE_SPACE

setopt  HIST_REDUCE_BLANKS

# zsh.zshrc is end here
