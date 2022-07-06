# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
if [ -f ${HOME}/.zplug/init.zsh ]; then
    source ${HOME}/.zplug/init.zsh
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(z git zsh-syntax-highlighting zsh-autocomplete zsh-autosuggestions gcloud vscode docker kubectl kubectx colored-man-pages python pip history sudo dirhistory )

# Plugins
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/osx",   from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "clvv/fasd"
zplug "b4b4r07/enhancd"
zplug "junegunn/fzf"
zplug "Peltoche/lsd"
zplug "romkatv/powerlevel10k", as:theme, depth:1

# include Z, yo
. ~/z.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# User configuration
export DEFAULT_USER="$(whoami)"

# kubectl
source <(kubectl completion zsh)
alias k='kubectl'
compdef __start_kubectl k
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Alias custom para GKE
alias r2='/home/dib/Private/sysadmin-tools/rke_byadhoc.sh'
alias rk='rancher2 kubectl'
alias gcp-lab='gcloud config set project proyecto-laboratorios'
alias gcp-prod='gcloud config set project nubeadhoc'

alias upd='sudo apt update'
alias upg='sudo apt upgrade'
alias untar='tar -zxvf' # Unpack .tar file

# McFly - fly through your shell history
# https://github.com/cantino/mcfly
eval "$(mcfly init zsh)"
