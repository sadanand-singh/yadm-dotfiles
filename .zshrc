# Created by newuser for 5.7.1

# Enable Powerlevel10k instant prompt. Should stay at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

#
# Exports
#

module_path+=("$HOME/.zinit/bin/zmodules/Src"); zmodload zdharma/zplugin &>/dev/null

typeset -g HISTSIZE=290000 SAVEHIST=290000 HISTFILE=~/.zsh_history ABSD=${${(M)OSTYPE:#*(darwin|bsd)*}:+1}

typeset -ga mylogs
zflai-msg() { mylogs+=( "$1" ); }
zflai-assert() { mylogs+=( "$4"${${${1:#$2}:+FAIL}:-OK}": $3" ); }

(( ABSD )) && {
    export LSCOLORS=dxfxcxdxbxegedabagacad CLICOLOR="1"
}

export EDITOR="nvim" VISUAL="nvim" LESS="-iRFX" CVS_RSH="ssh"

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="$(mktemp -d)"
fi

TMPPREFIX="${TMPDIR%/}/zsh"


umask 022

#
# Setopts
#

setopt interactive_comments hist_ignore_dups  octal_zeroes   no_prompt_cr
setopt no_hist_no_functions no_always_to_end  append_history list_packed
setopt inc_append_history   complete_in_word  no_auto_menu   auto_pushd
setopt pushd_ignore_dups    no_glob_complete  no_glob_dots   c_bases
setopt numeric_glob_sort    share_history  promptsubst    auto_cd
setopt rc_quotes            extendedglob      notify         correct_all

#setopt IGNORE_EOF
#setopt NO_SHORT_LOOPS
#setopt PRINT_EXIT_VALUE
#setopt RM_STAR_WAIT

#
# Bindkeys
#

autoload up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -e

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

zflai-assert "${+terminfo[kpp]}${+terminfo[knp]}${+terminfo[khome]}${+terminfo[kend]}" "1111" "terminfo test" "[zshrc] "

bindkey "^A"      beginning-of-line     "^E"      end-of-line
bindkey "^?"      backward-delete-char  "^H"      backward-delete-char
bindkey "^W"      backward-kill-word    "\e[1~"   beginning-of-line
bindkey "\e[7~"   beginning-of-line     "\e[H"    beginning-of-line
bindkey "\e[4~"   end-of-line           "\e[8~"   end-of-line
bindkey "\e[F"    end-of-line           "\e[3~"   delete-char
bindkey "^J"      accept-line           "^M"      accept-line
bindkey "^T"      accept-line           "^R"      history-incremental-search-backward

#
# Modules
#

zmodload -i zsh/complist

#
# Autoloads
#

autoload -Uz allopt zed zmv zcalc colors
colors

autoload -Uz edit-command-line
zle -N edit-command-line
#bindkey -M vicmd v edit-command-line

autoload -Uz select-word-style
select-word-style shell

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

#
# Aliases
#

alias gcc9=gcc-9
alias vi=nvim
alias vim=nvim
alias sq_summary='ssh wg-sadanand@10.27.119.121 python3 /storage/group/whiterabbit/slurm-summary/sq_summary.py'

function mkcd() {
    mkdir -p $1
    cd $1
}

function pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
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

alias calc="bc_convert"

alias pl='print -rl --'
#alias ls="gls -bh --color=auto"
alias py37="pyenv activate py37-dev"
alias ls="exa -bh --color=auto"
alias k="k -A"
alias l.='ls -d .*'   la='ls -lah'   ll='ls -lbt created'  l='la' rm='command rm -i'
alias df='df -h'  du='du -h'      cp='cp -v'   mv='mv -v'      plast="last -20"
alias reload="exec $SHELL -l -i"  grep="command grep --colour=auto --binary-files=without-match --directories=skip"
alias lynx="command lynx -accept-all-cookies"  ult="ulimit -c 195312; echo $$"
ulimit -c unlimited

# Git
alias g1log_branches="git log --color=always --oneline --decorate --graph --branches"
alias g1log_branches_intag="echo You can append a tag name; LANG=C sleep 0.5; git log --color=always --oneline --decorate --graph --branches"
alias g1log_simplify_decfull="git log --color=always --decorate=full --simplify-by-decoration"
alias g1log_simplify="git log --color=always --simplify-by-decoration --decorate"

# Image Magick
alias i1montage_concat_topbo_black="montage -mode concatenate -tile 1x -background black"
alias i1montage_concat_topbo_white="montage -mode concatenate -tile 1x -background white"
alias i1convert_append_topbo_black="convert -append -background black"
alias i1convert_append_topbo_white="convert -append -background white"
alias i1convert_append_lefri_black="convert +append -background black"
alias i1convert_append_lefri_white="convert +append -background white"

# Quick typing
alias n1ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias n1ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias n1sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias n1httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Show/hide hidden files in Finder
alias x1show_hidden="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias x1hide_hidden="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias x1hide_desktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias x1show_desktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Disable / enable Spotlight
alias x1spotoff="sudo mdutil -a -i off"
alias x1spoton="sudo mdutil -a -i on"

# Flush Directory Service cache
alias x1flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

alias x1mute="osascript -e 'set volume output muted true'"
alias x1lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

alias cask="brew cask"
alias capc="screencapture -c"
alias capic="screencapture -i -c"
alias capiwc="screencapture -i -w -c"

CAPTURE_FOLDER="$HOME/Downloads"

function cap() {
    screencapture "${CAPTURE_FOLDER}/capture-$(date +%Y%m%d_%H%M%S).png"
}

function capi() {
    screencapture -i "${CAPTURE_FOLDER}/capture-$(date +%Y%m%d_%H%M%S).png"
}

function capiw() {
    screencapture -i -w "${CAPTURE_FOLDER}/capture-$(date +%Y%m%d_%H%M%S).png"
}

#
# General tools
#

alias newest_ls="ls -lh --sort date -r --color=always | head -25"
alias cpfile="rsync --progress"
alias zmv='noglob zmv -w'
alias recently_changed='find . -newerct "15 minute ago" -print'
recently_changed_x() { find . -newerct "$1 minute ago" -print; }
alias -g SPRNG=" | curl -F 'sprunge=<-' http://sprunge.us"

#
# Patches for various problems
#

alias slocate='locate'
alias updatedb="sudo /usr/libexec/locate.updatedb"

# alias ls=psls ... - retain ls options but substitute the command with psls
if altxt=`alias ls`; then
    altxt="${altxt#alias }" # for sh
    if [ "$altxt" != "${altxt#ls=\'(ls|exa)}" ]; then
        altxt=${altxt#ls=\'exa}
        altxt=${altxt%\'}
        altxt="ls=psls$altxt"
        alias "$altxt"
        zflai-msg "[zshrc] \`ls' alias: $altxt"
    fi
else
    alias ls="psls"
    zflai-msg "[zshrc] \`ls' alias: ls=psls"
fi

unset altxt

fpath+=( $HOME/.zsh_functions)

autoload -Uz psprobe_host   psffconv    pssetup_ssl_cert    psrecompile    pscopy_xauth  \
             psls           pslist      psfind \
             mandelbrot     optlbin_on  optlbin_off         localbin_on    localbin_off    g1all   g1zip \
             zman \
             t1uncolor 	    t1fromhex   t1countdown \
             f1rechg_x_min  f1biggest \
             n1gglinks      n1dict      n1diki              n1gglinks      n1ggw3m         n1ling  n1ssl_tunnel \
	     n1ssl_rtunnel  \
             pngimage       deploy-code deploy-message

autoload +X zman
functions[zzman]="${functions[zman]}"
function run_diso {
  sh -c "$@" &
  disown
}

function pbcopydir {
  pwd | tr -d "\r\n" | pbcopy
}

function ip {
    curl -Ss icanhazip.com
}

function ips {
    ifconfig | grep "inet " | awk '{ print $2 }'
    echo "External: $(ip)"
}

function update {
    echo "update brew, zsh, zinit and mac app store"
    echo 'start updating ...'

    echo 'updating homebrew'
    brew update
    brew upgrade
    brew cleanup

    echo 'updating zsh shell'
    zinit self-update
    zinit update -p

    echo 'checking Apple Updates'
    /usr/sbin/softwareupdate -ia
}

function from-where {
    echo $^fpath/$_comps[$1](N)
    whence -v $_comps[$1]
    #which $_comps[$1] 2>&1 | head
}

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

localbin_on

#PS1="READY > "
zstyle ":plugin:zconvey" greeting "none"
zstyle ':notify:*' command-complete-timeout 3
zstyle ':notify:*' notifier plg-zsh-notify

palette() { local colors; for n in {000..255}; do colors+=("%F{$n}$n%f"); done; print -cP $colors; }

zflai-msg "[zshrc] ssl tunnel PID: $!"

#
# Zplugin
#

typeset -F4 SECONDS=0

[[ ! -f ~/.zinit/bin/zinit.zsh ]] && {
    command mkdir -p ~/.zinit
    command git clone https://github.com/zdharma/zinit ~/.zinit/bin
}

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zplugin annexes
# zinit-zsh/z-a-man \
zinit light-mode for \
    zinit-zsh/z-a-test \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-submods \
    zinit-zsh/z-a-bin-gem-node \
    zinit-zsh/z-a-rust

# Fast-syntax-highlighting & autosuggestions
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    zdharma/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions

# lib/git.zsh is loaded mostly to stay in touch with the plugin (for the users)
# and for the themes 2 & 3 (lambda-mod-zsh-theme & lambda-gitster)
zinit wait lucid for \
    zdharma/zsh-unique-id \
    OMZ::lib/git.zsh \
 atload"unalias grv g" \
    OMZ::plugins/git/git.plugin.zsh

# Theme no. 1 - zprompts
zinit lucid \
 load'![[ $MYPROMPT = 1 ]]' \
 unload'![[ $MYPROMPT != 1 ]]' \
 atload'!promptinit; typeset -g PSSHORT=0; prompt sprint3 yellow red green blue' \
 nocd for \
    psprint/zprompts

# Theme no. 2 – lambda-mod-zsh-theme
zinit lucid load'![[ $MYPROMPT = 2 ]]' unload'![[ $MYPROMPT != 2 ]]' nocd for \
    halfo/lambda-mod-zsh-theme

# Theme no. 3 – lambda-gitster
zinit lucid load'![[ $MYPROMPT = 3 ]]' unload'![[ $MYPROMPT != 3 ]]' nocd for \
    ergenekonyigit/lambda-gitster

# Theme no. 4 – geometry
zinit lucid load'![[ $MYPROMPT = 4 ]]' unload'![[ $MYPROMPT != 4 ]]' \
 atload'!geometry::prompt' nocd \
 atinit'GEOMETRY_COLOR_DIR=63 GEOMETRY_PATH_COLOR=63' for \
    geometry-zsh/geometry

# Theme no. 5 – pure
zinit lucid load'![[ $MYPROMPT = 5 ]]' unload'![[ $MYPROMPT != 5 ]]' \
 pick"/dev/null" multisrc"{async,pure}.zsh" atload'!prompt_pure_precmd' nocd for \
    sindresorhus/pure

# Theme no. 6 - agkozak-zsh-theme
zinit lucid load'![[ $MYPROMPT = 6 ]]' unload'![[ $MYPROMPT != 6 ]]' \
 atload'!_agkozak_precmd' nocd atinit'AGKOZAK_FORCE_ASYNC_METHOD=subst-async' for \
    agkozak/agkozak-zsh-theme

# Theme no. 7 - zinc
zinit load'![[ $MYPROMPT = 7 ]]' unload'![[ $MYPROMPT != 7 ]]' \
 compile"{zinc_functions/*,segments/*,zinc.zsh}" nocompletions \
 atload'!prompt_zinc_setup; prompt_zinc_precmd' nocd for \
    robobenklein/zinc

# Theme no. 8 - powerlevel10k
zinit load'![[ $MYPROMPT = 8 ]]' unload'![[ $MYPROMPT != 8 ]]' \
 atload'!source ~/.p10k.zsh; _p9k_precmd' lucid nocd for \
    romkatv/powerlevel10k

# Theme no. 9 - git-prompt
zinit lucid load'![[ $MYPROMPT = 9 ]]' unload'![[ $MYPROMPT != 9 ]]' \
 atload'!_zsh_git_prompt_precmd_hook' nocd for \
    woefe/git-prompt.zsh

# zunit, color
zinit wait"2" lucid as"null" for \
 sbin atclone"./build.zsh" atpull"%atclone" \
    molovo/zunit \
 sbin"color.zsh -> color" \
    molovo/color

# revolver
zinit wait"2" lucid as"program" pick"revolver" for psprint/revolver

# On OSX, you might need to install coreutils from homebrew and use the
# g-prefix – gsed, gdircolors
: zinit wait"0c" lucid reset \
 atclone"local P=${${(M)OSTYPE:#*darwin*}:+g}
        \${P}sed -i \
        '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
        \${P}dircolors -b LS_COLORS > c.zsh" \
 atpull'%atclone' pick"c.zsh" nocompile'!' \
 atload'zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}";' for \
    trapd00r/LS_COLORS

# Zconvey shell integration plugin
zinit wait lucid \
 sbin"cmds/zc-bg-notify" sbin"cmds/plg-zsh-notify" for \
    zdharma/zconvey

# zsh-startify, a vim-startify like plugin
: zinit wait"0b" lucid atload"zsh-startify" for zdharma/zsh-startify
zinit wait lucid pick"manydots-magic" compile"manydots-magic" for knu/zsh-manydots-magic

# fzy
zinit wait"1" lucid as"program" pick"$ZPFX/bin/fzy*" \
 atclone"cp contrib/fzy-* $ZPFX/bin/" \
 make"!PREFIX=$ZPFX install" for \
    jhawthorn/fzy

# remark
zinit wait'1c' lucid id-as'remark' \
 sbin'n:node_modules/.bin/remark' \
 node'remark <- !remark-cli; remark-man' for \
    zdharma/null

# zsh-autopair
# fzf-marks, at slot 0, for quick Ctrl-G accessibility
zinit wait lucid for \
    hlissner/zsh-autopair \
    urbainvaes/fzf-marks

# aditional plugins
zinit ice wait lucid
zinit light 'mattberther/zsh-pyenv'

zinit ice wait lucid
zinit light 'supercrabtree/k'

zinit ice wait lucid
zinit light 'agkozak/zsh-z'

zinit ice wait lucid
zinit light 'wookayin/fzf-fasd'

zinit ice wait lucid
zinit light 'RobertAudi/tsm'

zinit ice wait lucid
zinit light 'le0me55i/zsh-extract'

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    'esc/conda-zsh-completion'

# code stats
CODESTATS_API_KEY="SFMyNTY.YzJGa1lXNWhibVF0YzJsdVoyZz0jI05UZ3lOQT09.uVT5g3YcHPPkcAyOJegZsr_gS_xKTDP4vjr3gqoKVOI"
zinit ice from"gitlab"
zinit light "code-stats/code-stats-zsh"

#nvm
export NVM_LAZY_LOAD=true
zinit ice wait lucid
zinit light 'lukechilds/zsh-nvm'

# A few wait1 plugins
zinit wait"1" lucid for \
    psprint/zsh-navigation-tools \
 atinit'zstyle ":history-search-multi-word" page-size "7"' \
    zdharma/history-search-multi-word \
 atinit"local zew_word_style=whitespace" \
    psprint/zsh-editing-workbench

# Gitignore plugin – commands gii and gi
zinit wait"2" lucid trigger-load'!gi;!gii' \
 dl'https://gist.githubusercontent.com/psprint/1f4d0a3cb89d68d3256615f247e2aac9/raw -> templates/Zsh.gitignore' \
 for \
    voronkovich/gitignore.plugin.zsh

# F-Sy-H automatic themes – available for patrons
# https://patreon.com/psprint
: zinit wait"1" lucid from"psprint@gitlab.com" for psprint/fsh-auto-themes

# ogham/exa, sharkdp/fd, fzf
zinit wait"2" lucid as"null" from"gh-r" for \
    mv"exa* -> exa" sbin  ogham/exa \
    mv"fd* -> fd" sbin"fd/fd"  @sharkdp/fd \
    sbin junegunn/fzf-bin

# A few wait'2' plugins
zinit wait"2" lucid for \
    zdharma/declare-zsh \
    zdharma/zflai \
 blockf \
    zdharma/zui \
    zinit-zsh/zinit-console \
 atinit"forgit_ignore='fgi'" \
    wfxr/forgit

# git-cal
zinit wait"2" lucid as"null" \
 atclone'perl Makefile.PL PREFIX=$ZPFX' \
 atpull'%atclone' make sbin"git-cal" for \
    k4rthik/git-cal

# A few wait'3' git extensions
zinit as"null" wait"3" lucid for \
    sbin Fakerr/git-recall \
    sbin paulirish/git-open \
    sbin paulirish/git-recent \
    sbin davidosomething/git-my \
    sbin atload"export _MENU_THEME=legacy" \
        arzzen/git-quick-stats \
    make"PREFIX=$ZPFX"         tj/git-extras \
    sbin"bin/git-dsf;bin/diff-so-fancy" zdharma/zsh-diff-so-fancy \
    sbin"git-url;git-guclone" make"GITURL_NO_CGITURL=1" zdharma/git-url

# Notifications, configured to use zconvey
: zinit wait lucid for marzocchi/zsh-notify

zflai-msg "[zshrc] Zplugin block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"

# powerlevel10k
MYPROMPT=8

# # Load within zshrc – for the instant prompt
zinit atload'!source ~/.p10k.zsh' lucid nocd for romkatv/powerlevel10k

# Zstyles & other
#

zle -N znt-kill-widget
bindkey "^[kk" znt-kill-widget

cdpath=( "$HOME" "$HOME/Projects" "$HOME/Downloads" "$HOME/Projects/reckoning.dev" )

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:descriptions' format $'%{\e[0;33m%} %B%d%b%{\e[0m%}'
zstyle ':completion:*:*:*:default' menu yes select search
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion::complete:*' gain-privileges 1
#zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”

source /Users/sadanand/.zinit/plugins/tj---git-extras/etc/git-extras-completion.zsh

function double-accept { deploy-code "BUFFER[-1]=''"; }
zle -N double-accept
bindkey -M menuselect '^F' history-incremental-search-forward
bindkey -M menuselect '^R' history-incremental-search-backward
bindkey -M menuselect ' ' .accept-line

function mem() { ps -axv | grep $$  }

zflai-msg "[zshrc] Finishing, loaded custom modules: ${(j:, :@)${(k)modules[@]}:#zsh/*}"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  "/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin"
  /usr/local/opt/openssl@1.1/bin
  /usr/local/opt/openssl/bin
  /usr/local/opt/curl/bin
  $path
)

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PATH
