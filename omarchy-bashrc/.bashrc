# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# --- System and Common Commands Aliases ---
alias c='clear'
alias mkdir='mkdir -p'
alias shutdown='shutdown now'

# --- Navigation (cd) Aliases ---
alias downloads='cd ~/.Downloads'
alias dotfiles='cd ~/dotfiles'
alias desktop='cd ~/Desktop'
alias documents='cd ~/Documents'
alias music='cd ~/Music'
alias pictures='cd ~/Pictures'
alias public='cd ~/Public'
alias templates='cd ~/Templates'
alias videos='cd ~/Videos'

# Parent directory navigation
alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
alias .7='cd ../../../../../../../'
alias .8='cd ../../../../../../..'
alias .9='cd ../../../../../../../..'
alias .10='cd ../../../../../../../../..'

# --- Pacman and Yay Aliases ---
# Pacman operations
alias pacinstall='sudo pacman -S'       # Install packages
alias pacremove='sudo pacman -Rns'      # Remove packages and their dependencies/config
alias pacsearch='pacman -Ss'            # Search packages
alias pacinfo='pacman -Qi'              # Get information about installed package
alias pacfiles='pacman -Ql'             # List files owned by a package

# Yay operations (AUR helper)
alias yayinstall='yay -S'
alias yayremove='yay -Rns'
alias yaysearch='yay -Ss'
alias yayinfo='yay -Qi'

# System Updates
alias pacupdate='sudo pacman -Syu'      # Update system with pacman
alias yayupdate='yay -Syu'              # Update system with yay (includes pacman sync)

# --- Git Aliases ---
alias clone='git clone'
alias clonedepth1='git clone --depth=1'
# Git Add, Commit (General), Push
alias gacp='git add -A && git commit -m "General commit" && git push'

# gitkeep function: checks for a git repo, then adds .gitkeep to empty subdirectories
function gitkeep() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not a git repository. Cannot run gitkeep."
    return 1
  fi
  # Find empty directories recursively (excluding the .git folder) and touch a .gitkeep file inside
  find . -type d -empty -not -path './.git/*' -exec touch {}/.gitkeep \;
  echo ".gitkeep files added to all empty subdirectories."
}
alias gitkeep='gitkeep'

# --- Development and Environment Aliases ---
# Developing (cd and open nvim)
alias developingnvim='cd ~/developing-projects && nvim'
alias javanvim='cd ~/developing-projects/java-projects/ && nvim'
alias pythonnvim='cd ~/developing-projects/python-projects/ && nvim'

# SSH Access
alias nas-ssh='cloudflared access ssh --hostname ssh.nicolkrit.ch'
