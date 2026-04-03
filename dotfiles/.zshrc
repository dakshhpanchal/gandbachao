# instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zinit
source ~/.local/share/zinit/zinit.git/zinit.zsh

# history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# env
export PATH=$HOME/.local/bin:$PATH
export EDITOR="code --wait --reuse-window"
export ROS_DOMAIN_ID=0
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export GZ_SIM_SYSTEM_PLUGIN_PATH=$GZ_SIM_SYSTEM_PLUGIN_PATH:/opt/ros/jazzy/lib
export GZ_SIM_RESOURCE_PATH=/home/soap/probes/mercury/install/simulation/share/simulation/models
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH

# options
setopt no_beep
fpath=(~/.zsh/completions $fpath)

# completion
autoload -Uz compinit compaudit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

if [[ ! -f "$ZSH_COMPDUMP" || -z "$ZSH_COMPDUMP" || $(find "$ZSH_COMPDUMP" -mtime +1 2>/dev/null) ]]; then
  compinit
  compaudit -D
else
  compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

zmodload zsh/complist
_comp_options+=(globdots)

# plugins
zinit ice depth=1
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# aliases
alias ls='ls --color --group-directories-first -v'
alias ll='ls -la --color --group-directories-first -v'
alias c='clear'
alias vim='nvim'
alias vs='code'
alias python='python3'
alias gk='pkill -9 gzserver ; pkill -9 gzclient'
alias ra='ranger'
alias sr='source /opt/ros/jazzy/setup.zsh'
alias build='colcon build && source /opt/ros/jazzy/setup.zsh && source install/setup.zsh && ros2 launch bringup bringup_sim.launch.py'

# functions
gpp() {
  out="${1%.*}"
  g++ "$1" -o "$out"
}

# keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# p10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# terminal title
precmd() { print -Pn "\e]0;%~\a" }
