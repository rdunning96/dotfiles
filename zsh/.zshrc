# Load Angular CLI autocompletion.
source <(ng completion script)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

setopt HIST_IGNORE_ALL_DUPS

alias c='clear'
alias tc='vi ~/.zshrc'
alias tmuxconfig='vi ~/.tmux.conf'
alias restart='source ~/.zshrc && clear'
alias dev='cd ~/Source/Active'
alias gs='git status'
alias ga='git add'
alias gc='git checkout'
alias gcm='git commit -m'
alias gp='git pull'
alias gb='git branch'
alias gcb='git checkout -b'
alias gpom='git pull origin main'
alias ll='ls -gGAFlh' 
alias la='ls -a'
alias th='vi ~/.zsh_history'
alias bucc='brew upgrade claude-code'

# pnpm
export PNPM_HOME="/Users/ryandunning/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:$HOME/.maestro/bin
export PATH=$PATH:$HOME/.maestro/bin

# Claude/Codex agent sandboxes
export SANDBOX_COMPOSE=~/claude-sandbox/docker-compose.yml

alias claude-agent='PROJECT_PATH=$(pwd) docker compose -f $SANDBOX_COMPOSE run --rm claude'
alias codex-agent='PROJECT_PATH=$(pwd) docker compose -f $SANDBOX_COMPOSE run --rm codex'
