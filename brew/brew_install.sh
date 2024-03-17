#!/bin/bash

INSTALL_DIR="$HOME/goinfre/.brew"

#                         #
#                    #         #
#                #                 #
#            #                         #
#        #                                 #
#    #                                         #
#    #                                     #####
#    #                                 #########
#    #                             #############
#    #                         #################
#    #                    ######################
#    #                    ####   ###############
#    #                    ### ### ############## 
#    #                    #### #################
#    #                    ####### ####### ######
#        #                ### ### ### #####
#            #            ####   #####
#                #        ##########
#                    #    #####
#                         #


 
# Specify the installation directory


# Delete and reinstall Homebrew from Github repo
rm -rf "$INSTALL_DIR"
git clone --depth=1 https://github.com/Homebrew/brew "$INSTALL_DIR"

# Create .brewconfig script in the installation directory
cat > "$INSTALL_DIR/.brewconfig.zsh" <<EOL
# HOMEBREW CONFIG

# Add brew to path
export PATH=$INSTALL_DIR/bin:\$PATH

# Set Homebrew temporary folders
export HOMEBREW_CACHE=/tmp/\$USER/Homebrew/Caches
export HOMEBREW_TEMP=/tmp/\$USER/Homebrew/Temp

mkdir -p \$HOMEBREW_CACHE
mkdir -p \$HOMEBREW_TEMP

# If NFS session
# Symlink Locks folder in /tmp
if df -T autofs,nfs \$HOME 1>/dev/null; then
  HOMEBREW_LOCKS_TARGET=/tmp/\$USER/Homebrew/Locks
  HOMEBREW_LOCKS_FOLDER=$INSTALL_DIR/.brew/var/homebrew

  mkdir -p \$HOMEBREW_LOCKS_TARGET
  mkdir -p \$HOMEBREW_LOCKS_FOLDER

  # Symlink to Locks target folders
  # If not already a symlink
  if ! [[ -L \$HOMEBREW_LOCKS_FOLDER && -d \$HOMEBREW_LOCKS_FOLDER ]]; then
     echo "Creating symlink for Locks folder"
     rm -rf \$HOMEBREW_LOCKS_FOLDER
     ln -s \$HOMEBREW_LOCKS_TARGET \$HOMEBREW_LOCKS_FOLDER
  fi
fi
EOL

# Add .brewconfig sourcing in your .zshrc if not already present
if ! grep -q "# Load Homebrew config script" "$HOME/.zshrc"; then
    cat >> "$HOME/.zshrc" <<EOL

# Load Homebrew config script
source "$INSTALL_DIR/.brewconfig.zsh"
EOL
fi

source "$INSTALL_DIR/.brewconfig.zsh"
rehash
brew update

echo -e "\nPlease open a new shell to finish installation"
