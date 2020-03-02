# simple bashrc with nice prompt
# link: https://gist.github.com/aslpavel/5925739
# install: wget --no-check-certificate -q -O - https://gist.github.com/aslpavel/5925739/download | tar -xzO -f- --strip-components=1 > "$HOME/.bashrc"

[ -z "$PS1" ] && return


### PROMPT
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

case $TERM in
linux|rxvt)
    col_user=3
    col_host=3
    col_base=0
    col_tags=(1 5 2)
    seg_sep=""
    seg(){
        echo -n "\\["
        test -z "$1" || echo -n "\\033[3$1m"
        test -z "$2" || echo -n "\\033[4$2m"
        echo -n "\\]$3\\[\\033[m\\]"
    }
;;
*)
    if [ "_$(tput colors 2>/dev/null)" != "_256" ]; then
        export TERM="xterm-256color"
    fi

    # https://jonasjacek.github.io/colors/
    col_user=178
    col_host=136
    col_base=235
    col_git=34
    col_tags=(131 61 29)
    #seg_sep=$(printf "\xee\x82\xb0")
		seg_sep=""
    seg(){
        echo -n "\\["
        test -z "$1" || echo -n "\\033[38;5;$1m"
        test -z "$2" || echo -n "\\033[48;5;$2m"
        echo -n "\\]$3\\[\\033[m\\]"
    }
;;
esac
if [ $UID -eq 0 ]; then
    col_tag=${col_tags[0]}
else
    case $(uname) in
    Darwin|FreeBSD)
        col_tag=${col_tags[1]}
    ;;
    Linux|CYGWIN*)
        col_tag=${col_tags[2]}
    ;;
    esac
fi
segs=("$(seg $col_user $col_base ' \u')"
      "$(seg $col_host $col_base '@\h ')"
      "$(seg $col_base $col_tag $seg_sep)"
      "$(seg $col_base $col_tag ' \w ')"
      "$(seg $col_git $col_base '$(parse_git_branch)')"
      "$(seg $col_tag '' $seg_sep' ')")
unset -f seg
unset col_user col_host col_base col_tag col_tags seg_sep


PS1=""
for seg in "${segs[@]}"; do
    PS1="${PS1}${seg}"
done
unset seg segs


### PATH
paths=("$HOME/.bin"
       "$HOME/.local/bin"
       "$HOME/.gem/ruby/2.0.0/bin"
       "$HOME/.cabal/bin"
			)
for path in "${paths[@]}"; do
    if echo -n "$path" | grep -q $PATH; then
        continue
    fi
    PATH="$path:$PATH"
done
export PATH
unset path paths


### VARIABLES
export EDITOR="vim"
export LANG="en_US.UTF-8"


### ALIASES
case $(uname) in
Darwin|FreeBSD)
    alias l='locate -i'
    alias ls='ls -GF'
		alias ll='ls -al'
		alias vi='vim'
;;
Linux|CYGWIN*)
    alias l='locate -ir'
    alias p_mem='ps -eo pid,pcpu,rss,vsize,stat,wchan,user,cmd --sort -rss'
    alias p_cpu='ps -eo pid,pcpu,rss,vsize,stat,wchan,user,cmd --sort -pcpu'
    if [ -x /usr/bin/dircolors ]; then
        eval $(dircolors -b)
        alias ls='ls --classify --color=auto'
        alias grep='grep --color=auto'
    fi
;;
esac


### FUNCTIONS
f(){
    find ./ -iname "*$1*"
}
bashrc_update(){
    local repo=https://gist.github.com/aslpavel/5925739/download
    wget --no-check-certificate -q -O - "$repo" |
    tar -xzO -f- --strip-components=1 > "$HOME/.bashrc"
    source "$HOME/.bashrc"
}


### SETTINGS
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


### LS_COLORS
if test -f "$HOME/.config/dircolors" && type -f dircolors &>/dev/null; then
    eval $(dircolors "$HOME/.config/dircolors")
fi

##
# Your previous /Users/seungmi/.bash_profile file was backed up as /Users/seungmi/.bash_profile.macports-saved_2016-05-19_at_14:59:48
##

# MacPorts Installer addition on 2016-05-19_at_14:59:48: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


##
# Your previous /Users/seungmi/.bash_profile file was backed up as /Users/seungmi/.bash_profile.macports-saved_2016-05-19_at_15:02:59
##

# MacPorts Installer addition on 2016-05-19_at_15:02:59: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

### open ssl
# If you need to have openssl@1.1 first in your PATH run:
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# For compilers to find openssl@1.1 you may need to set:
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"

# For pkg-config to find openssl@1.1 you may need to set:
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"


### zlib
#For compilers to find zlib you may need to set:
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"

#For pkg-config to find zlib you may need to set:
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"


# ebcli 
# export PATH="/Users/seungmi/.ebcli-virtual-env/executables:$PATH"

# pyspark
# export SPARK_HOME="/Users/seungmi/dev/glue/spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8"
