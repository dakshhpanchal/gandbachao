# -------------------------------------------------------------------------- #
# ZSH PROFILER (FOR DEBUGGING ONLY)
# Remove the two zprof lines below when finished debugging.
# zmodload zsh/zprof

# -------------------------------------------------------------------------- #
# Powerlevel10k Instant Prompt Pre-Initialization
# MUST be near the top. Any console output above the .p10k.zsh source is bad.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------------------------------------------------------------- #
# Zinit Plugin Manager Initialization
source ~/.local/share/zinit/zinit.git/zinit.zsh

# -------------------------------------------------------------------------- #
# Zsh Variables and Settings (FAST)

# History settings (Moved up, as these are fast)
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups \
       hist_save_no_dups hist_ignore_dups hist_find_no_dups

# Environment variables (Moved up, as these are fast)
export PATH=$HOME/.local/bin:$PATH
export ROS_DOMAIN_ID=0
export EDITOR="code --wait --reuse-window"

# Misc settings
setopt no_beep
fpath=(~/.zsh/completions $fpath)

# -------------------------------------------------------------------------- #
# COMPLETIONS OPTIMIZATION (THE MAIN BOTTLENECK)

# 1. Load the completion functions
autoload -Uz compinit compaudit

# 2. Check for cache file and use conditional loading (Fixes 85% of delay)
# Check for cache dump file. We check for a file older than 24 hours.
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
if [ ! -f "$ZSH_COMPDUMP" ] || [ -z "$ZSH_COMPDUMP" ] || \
   [[ $(find "$ZSH_COMPDUMP" -mtime +1 2>/dev/null) ]]; then
    # Cache is old/missing: Re-run compinit and compaudit
    compinit
    # Run compaudit only if needed, silence errors with -D to avoid P10k warning
    compaudit -D
else
    # Cache is fresh: Load compinit directly from cache
    compinit -C
fi

# 3. Zinit and Completion Plugins (Must be AFTER compinit for plugins to work)
# zsh-users/zsh-completions should be loaded AFTER the standard compinit call
zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions  # Zinit loads this plugin

# Completion settings (Must be AFTER compinit and plugin loading)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)

# -------------------------------------------------------------------------- #
# ALIASES AND FUNCTIONS (Must be after plugins are loaded, as they are fast)

# Aliases
alias ls='ls --color'
alias ll='ls -la'
alias c='clear'
alias vim='nvim'
alias vs='code'
alias python='python3'
alias gk='pkill -9 gzserver ; pkill -9 gzclient'
alias ra='ranger'

# Function to compile C++ files
gpp() {
    out="${1%.*}"
    g++ "$1" -o "$out"
}

# Key bindings for history search (Autosuggestions typically provides these)
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Powerlevel10k config (MUST be sourced after all plugins/settings)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Terminal title (P10k often handles this, but keeping your setting)
precmd() { print -Pn "\e]0;%~\a" }

# -------------------------------------------------------------------------- #
# PROFILER END
# zprofexport PATH="$PATH:$HOME/development/flutter/bin"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
#source /opt/ros/jazzy/setup.zsh
#source ~/probes/robotic_arm_ws/install/setup.zsh
