# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files source by it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'no'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'mac'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# ssh when connecting to these hosts.
zstyle ':z4h:ssh:10.27.119.121'   enable 'no'

# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over ssh to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return
z4h install supercrabtree/k || return
z4h install esc/conda-zsh-completion || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(
  /Library/TeX/texbin
  /opt/homebrew/{bin,sbin}
  /usr/local/{bin,sbin}
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  /usr/local/opt/openssl@1.1/bin
  /usr/local/opt/openssl/bin
  /usr/local/opt/sqlite/bin
  /usr/local/opt/ruby/bin
  /usr/local/opt/ncurses/bin
  /usr/local/opt/curl/bin
  $path
)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
z4h load   supercrabtree/k
z4h load   esc/conda-zsh-completion
z4h load   ohmyzsh/ohmyzsh/plugins/extract
z4h load   ohmyzsh/ohmyzsh/plugins/macos
z4h load   ohmyzsh/ohmyzsh/plugins/universalarchive

CODESTATS_API_KEY="SFMyNTY.YzJGa1lXNWhibVF0YzJsdVoyZz0jI05UZ3lOQT09.uVT5g3YcHPPkcAyOJegZsr_gS_xKTDP4vjr3gqoKVOI"
z4h load   code-stats/code-stats-zsh

# Define key bindings.
z4h bindkey undo Ctrl+/  # undo the last command line change
z4h bindkey redo Alt+/   # redo the last undone command line change

z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

bindkey "^A"      beginning-of-line     "^E"      end-of-line
bindkey "^?"      backward-delete-char  "^H"      backward-delete-char
bindkey "^W"      backward-kill-word    "\e[1~"   beginning-of-line
bindkey "\e[7~"   beginning-of-line     "\e[H"    beginning-of-line
bindkey "\e[4~"   end-of-line           "\e[8~"   end-of-line
bindkey "\e[F"    end-of-line           "\e[3~"   delete-char
bindkey "^J"      accept-line           "^M"      accept-line
bindkey "^T"      accept-line           "^R"      history-incremental-search-backward

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'
alias vi=nvim
alias vim=nvim

alias norg="gron --ungron"
alias ungron="gron --ungron"

function mkcd() {
    mkdir -p $1
    cd $1
}

# Remove python compiled byte-code and mypy/pytest cache in either the current
# directory or in a list of specified directories (including sub directories).
function pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
    find ${ZSH_PYCLEAN_PLACES} -depth -type d -name ".mypy_cache" -exec rm -r "{}" +
    find ${ZSH_PYCLEAN_PLACES} -depth -type d -name ".pytest_cache" -exec rm -r "{}" +
}

function man() {
    env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

function cdf() {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
        cd "$target"; pwd
    else
        echo 'No Finder window found' >&2
    fi
}

function realpath()
{
  CURR_PATH=$(pwd)
  TARGET_FILE=$1
  cd $(dirname ${TARGET_FILE})
  TARGET_FILE=$(basename ${TARGET_FILE})

  # Iterate down a (possible) chain of symlinks
  while [ -L "${TARGET_FILE}" ]
  do
      TARGET_FILE=$(readlink ${TARGET_FILE})
      cd $(dirname ${TARGET_FILE})
      TARGET_FILE=$(basename ${TARGET_FILE})
  done

  # Compute the canonicalized name by finding the physical path
  # for the directory we're in and appending the target file.
  PHYS_DIR=$(pwd -P)
  RESULT=${PHYS_DIR}/${TARGET_FILE}
  echo ${RESULT}
  cd ${CURR_PATH}
}

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line

function bc_convert {
  echo "$@" | bc
}

function gi() { curl -fLw '\n' https://www.gitignore.io/api/"${(j:,:)@}" }

_gitignoreio_get_command_list() {
  curl -sfL https://www.gitignore.io/api/list | tr "," "\n"
}

_gitignoreio () {
  compset -P '*,'
  compadd -S '' `_gitignoreio_get_command_list`
}

compdef _gitignoreio gi

# Median function
# Probably best to keep with Odd numbers
# $ median 5 7 3 4 9
# >>> 5
function median {
  echo  $@ | xargs -n1 | sort -n | sed -n $((($#+1)/2))p
}

# Mean function
function mean {
  # need to figure out how to take these from stdin and convert them to array
  test_nums=[1,2,3,4,5]
  mean=$(python -c "print(sum($test_nums) / len($test_nums))")
  echo $mean
}

function ip {
    curl -Ss icanhazip.com
}

function ips {
    ifconfig | grep "inet " | awk '{ print $2 }'
    echo "External: $(ip)"
}


alias calc="bc_convert"
alias pl='print -rl --'
alias ls='lsd -l'
alias l='lsd -l'
alias la='ls -lah'
alias lla='ls -lah'
alias ltree='ls --tree'
alias k="k -A"
alias l.='ls -d .*'   la='ls -lah'   ll='ls -lbt created'  l='la' rm='command rm -i'
alias df='df -h'  du='du -h'      cp='cp -v'   mv='mv -v'      plast="last -20"

# Image Magick
alias imgsize="identify -format '%w, %h\n'"

# Quick typing
alias n1ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias n1ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias n1sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias n1httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

alias newest_ls="ls -lh --sort date -r --color=always | head -25"
alias cpfile="rsync --progress"
alias recently_changed='find . -newerct "15 minute ago" -print'
recently_changed_x() { find . -newerct "$1 minute ago" -print; }


function lsgrep {
    export needle=$(echo $1 | sed -E 's/\.([a-z0-9]+)$/\\.\1/' | sed -E 's/\?/./' | sed -E 's/[ *]/.*?/g')
    command ag --depth 3 -S -g "$needle" 2>/dev/null
}

function lt {
    ls -Atr1 $1 && echo "⇡⎽⎽⎽⎽Newest⎽⎽⎽⎽⇡"
}

function ltr {
    ls -At1 $1 && echo "⇡⎽⎽⎽⎽Oldest⎽⎽⎽⎽⇡"
}

whichcomp() {
    for 1; do
        ( print -raC 2 -- $^fpath/${_comps[$1]:?unknown command}(NP*$1*) )
    done
}

osxnotify() {
    osascript -e 'display notification "'"$*"'"'
}

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# conda liases
alias py3="conda activate base"
alias unload_py="conda deactivate"
alias update_py="conda update --all"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(zoxide init zsh --cmd cd)"

