export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# Use powerline
USE_POWERLINE="true"
source /home/shaffaaf/antigen.zsh
# Source manjaro-zsh-configuration
# if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
#   source /usr/share/zsh/manjaro-zsh-config
# fi
# Use manjaro zsh prompt
# if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  # source /usr/share/zsh/manjaro-zsh-prompt
# fi
antigen use oh-my-zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# source /usr/share/nvm/init-nvm.sh

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle bgnotify
# antigen bundle asdf
antigen bundle command-not-found
antigen bundle zsh-users/zsh-completions
antigen bundle hlissner/zsh-autopair
antigen bundle b4b4r07/enhancd
# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
#perdirectory
antigen bundle jimhester/per-directory-history

# Load the theme.
#antigen theme robbyrussell
antigen theme ys

# Tell Antigen that you're done.
antigen apply

alias cls="clear"
alias cat="bat"
alias ls="exa"
alias vim="nvim"
alias kilall="killall"
alias killal="killal"
#
# set JAVA_HOME on every change directory
# function asdf_update_java_home {
#   asdf current java 2>&1 > /dev/null
#   if [[ "$?" -eq 0 ]]
#   then
#       export JAVA_HOME=$(asdf where java)
#   fi
# }

# precmd() { asdf_update_java_home; }
# end set JAVA_HOME

# Pathing
# . /opt/asdf-vm/asdf.sh
# . ~/.asdf/plugins/dotnet-core/set-dotnet-home.zsh
# export MSBuildSDKsPath="/home/shaffaaf/.asdf/installs/dotnet-core/5.0.400/sdk/5.0.400/Sdks"
# . ~/.asdf/plugins/java/set-java-home.zsh
export JAVA_HOME='/usr/lib/jvm/java-8-openjdk/jre/'
export PATH=$JAVA_HOME/bin:$PATH
export ENHANCD_COMPLETION_BEHAVIOR=list

export GOPATH='/home/shaffaaf/go'
export PATH=$PATH:$GOPATH/bin/



export ANDROID_SDK_ROOT='/opt/android-sdk'
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools/
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin/
export PATH=$PATH:$ANDROID_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/



eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
