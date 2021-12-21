#!/usr/bin/env bash

echo -e 'Install type? [basic[b]|kiosk[k]|plex[p]|logging[l]]'
read install_type
echo

if [[ $install_type == server || $install_type == s ]]
then
  sudo apt update
  sudo apt install vim zsh git curl rsync htop -y

  # nifty package that will tell you which package you need if you try to run a command for something not installed
  apt install command-not-found
  apt-file update
  update-command-not-found

  [//]: # install oh-my-zsh and configure plugins
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  [//]: # change default shell to ZSH
  chsh -s $(which zsh)

  if grep Raspberry /proc/cpuinfo; then
    #MOTD setup - I think this is only going to work on raspberry pi.. so we check
    sudo rm /etc/motd

    # nano /etc/ssh/sshd_config
    # PrintLastLog no
    # link the repo info motd to the proper place and make it executable

    sudo ln -sf "$(pwd)/etc/profile.d/motd.sh" /etc/profile.d/motd.sh
    sudo chmod +x /etc/profile.d/motd.sh

    ###
    ### Log2Ram Setup - Helps your poor little Pi SD card not get overwhelmed with logs
    ###
    wget https://github.com/azlux/log2ram/archive/master.tar.gz -O log2ram.tar.gz
    tar xf log2ram.tar.gz; cd log2ram-master
    sudo ./install.sh
  fi



  [//]: # install oh-my-zsh and configure plugins
  ln -sf "$(pwd)/.zshrc" $HOME/.zshrc
  ln -s "$(pwd)/.aliases" $HOME/.aliases
  ln -s "$(pwd)/.zprofile" $HOME/.zprofile
  ln -s "$(pwd)/.zlogout" $HOME/.zlogout
  ln -s "$(pwd)/.p10k.zsh" $HOME/.p10k.zsh

elif [[ $install_type == 'kiosk' ]]
then
  sudo apt-get --no-install-recommends install xserver-xorg xserver-xorg-video-fbdev xinit pciutils xinput xfonts-100dpi xfonts-75dpi xfonts-scalable chromium -y

# elif [[ $install_type == 'logging' ]]
# then
#   apt install
fi
