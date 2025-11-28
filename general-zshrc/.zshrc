# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/krit/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Export current java path to allow to use the current java version
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
# Export current jdtls path to allow to user the current java version
export JDTLS_BIN=$HOME/tools/jdtls/bin/jdtls

# Various eval
eval "$(starship init zsh)"

# Various commands to load at startup
fastfetch
