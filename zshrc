# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

unsetopt correct_all 
unsetopt correct

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Handle the fact that this file will be used with multiple OSs
platform=`uname`
if [[ $platform = 'Linux' ]]; then
  alias a='ls -lth --color'
  alias ls='ls --color=auto'
  export EDITOR="vim"
  alias get='sudo apt-get install'
elif [[ $platform = 'Darwin' ]]; then
  alias a='ls -lthG' # sort by date modified
  alias ls='ls -G'  # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
  export EDITOR='mate -w'  # OS-X SPECIFIC - TextMate, w is to wait for TextMate window to close
  alias lock="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
  alias flushdns="dscacheutil -flushcache"
fi

# ruby (irb)
alias irb='irb --readline -r irb/completion'

# Navigation and directory listing
alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias ll='ls -hl'
alias la='ls -ah'
alias lla='ls -lah'
alias lt='ls -th'
alias llt='ls -lth'
alias q='exit'

# SVN shortcuts
alias ss='svn st'
alias sup='svn up'
alias sci='svn ci'
alias sl='svn log'

# git shortcuts
alias changelog='git log `git log -1 --format=%H -- CHANGELOG*`..; cat CHANGELOG*'
alias dt='git difftool'
alias dtc='git difftool --cached'
alias dth='git difftool HEAD'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -am'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gdt='git difftool'
alias gg='git lg'
alias ggg='git logc'
alias gggg='git logd'
alias gl='git pull --rebase'
alias gp='git push'
alias g='git status -sb'
alias gs='git status'
alias grm='git status --porcelain | ruby -e "puts STDIN.read.scan(/^\\s+D\\s+(.+)\$/).join(\"\\n\")" | xargs git rm'
alias open_html='open -a Google\ Chrome build/*/index_us.html'
alias open_archived='open -a Google\ Chrome build/_archived/*/index_us.html'
alias open_firefox='open -a Firefox build/*/index_us.html'

# =============================
# = Directory save and recall =
# =============================

# I got the following from, and mod'd it: http://www.macosxhints.com/article.php?story=20020716005123797
#    The following aliases (save & show) are for saving frequently used directories
#    You can save a directory using an abbreviation of your choosing. Eg. save ms
#    You can subsequently move to one of the saved directories by using cd with
#    the abbreviation you chose. Eg. cd ms  (Note that no '$' is necessary.)
#    
#    Make sure to also set the appropriate shell option:
#    zsh:
#      setopt CDABLE_VARS
#    bash:
#      shopt -s cdable_vars

# if ~/.dirs file doesn't exist, create it
if [ ! -f ~/.dirs ]; then
  touch ~/.dirs
fi
# Initialization for the 'save' facility: source the .dirs file
source ~/.dirs

alias show='cat ~/.dirs'
alias showdirs="cat ~/.dirs | ruby -e \"puts STDIN.read.split(10.chr).sort.map{|x| x.gsub(/^(.+)=.+$/, '\\1')}.join(', ')\""

function save (){
  local usage
  usage="Usage: save shortcut_name"
  if [ $# -lt 1 ]; then
    echo "$usage"
    return 1
  fi
  if [ $# -gt 1 ]; then
    echo "Too many arguments!"
    echo "$usage"
    return 1
  fi
  if [ -z $(echo $@ | grep --color=never "^[a-zA-Z]\w*$") ]; then
    echo "Bad argument! $@ is not a valid alias!"
    return 1
  fi
  if [ $(cat ~/.dirs | grep --color=never "^$@=" | wc -l) -gt 0 ]; then
    echo -n "That alias is already set to: "
    echo $(cat ~/.dirs | awk "/^$@=/" | sed "s/^$@=//" | tail -1)
    echo -n "Do you want to overwrite it? (y/n) "
    read answer
    if [ ! "$answer" = "y" -a ! "$answer" = "yes" ]; then
      return 0
    else
      # backup just in case
      cp ~/.dirs ~/.dirs.bak
      # delete existing version(s) of this alias
      cat ~/.dirs | sed "/^$@=.*/d" > ~/.dirs.tmp
      mv ~/.dirs.tmp ~/.dirs
    fi
  fi
  # add a newline to the end of the file if necessary
  if [ $(cat ~/.dirs | sed -n '/.*/p' | wc -l) -gt $(cat ~/.dirs | wc -l) ]; then
    echo >> ~/.dirs
  fi
  echo "$@"=\"`pwd`\" >> ~/.dirs
  source ~/.dirs
  echo "Directory shortcuts:" `showdirs`
}
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/bin 
