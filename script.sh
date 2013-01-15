#!/bin/bash
# Nearsoft, Inc.
# Nearsoft Labs

# Make sure this script is not being executed as root
if [ "$(id -u)" == "0" ]; then
   echo "Don't run this script as root." 1>&2
   exit 1
fi

echo -e "\e[1;37mWelcome to Ruby2Go: The best way to install Ruby.\e[0m"    #Print logo

#########################################
### Choose the proper package manager ###
#########################################

pkm_apt_binary="$(     builtin command -v apt-get )"
pkm_emerge_binary="$(  builtin command -v emerge  )"
pkm_pacman_binary="$(  builtin command -v pacman  )"
pkm_yum_binary="$(     builtin command -v yum     )"
pkm_zypper_binary="$(  builtin command -v zypper  )"
pkm_pkg_add_binary="$( builtin command -v pkg_add )"

# Checks if evaluated package manager is installed

if [[ -n "$pkm_apt_binary" ]]; then
    pack="sudo apt-get install -y"
    rvm_dependencies="build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config"
elif [[ -n "$pkm_emerge_binary" ]]; then
    pack="sudo emerge"
    rvm_dependencies="libiconv readline zlib openssl curl git libyaml sqlite libxslt libtool gcc autoconf automake bison m4"
elif [[ -n "$pkm_pacman_binary" ]]; then
    pack="sudo pacman -Sy --noconfirm"
    rvm_dependencies="gcc patch curl zlib readline libxml2 libxslt git autoconf automake diffutils make libtool bison subversion"
elif [[ -n "$pkm_yum_binary" ]]; then
    pack="sudo yum install -y"
    rvm_dependencies="gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel"
elif [[ -n "$pkm_zypper_binary" ]]; then
    pack="sudo zypper install -y"
    rvm_dependencies="patterns-openSUSE-devel_basis gcc-c++ bzip2 readline-devel zlib-devel libxml2-devel libxslt-devel libyaml-devel libopenssl-devel libffi45-devel libtool bison"
elif [[ -n "$pkm_pkg_add_binary" ]]; then
    pack="sudo pkg_add"
    rvm_dependencies="gcc curl readline libxml2 libxslt git autoconf automake diffutils make libtool bison subversion"
else
    echo "No package manager found!"
    exit 2
fi

##################################################
### Functions for installation of requirements ###
##################################################

# Checks if a command exits: Returns 1 if the command exits
isInstalled(){
    if type $1 > /dev/null 2>&1; then
        echo "1"
    else echo "0"
    fi
}

install(){
    check=$(isInstalled $1);
    if [ $check == 0 ]; then
            echo -e "Installing $1." #A little print
            $pack $1
    fi
}

####################
### Installation ###
####################

install "curl"
install "git"

install "nodejs"

# Install RVM with curl
curl -L get.rvm.io | bash -s stable

source $HOME/.rvm/scripts/rvm

$pack $rvm_dependencies

rvm pkg install openssl
rvm install 1.9.3 --with-openssl-dir=$HOME/.rvm/usr

gem install rails

rvm use 1.9.3 --default
gem install execjs

# TODO: Generate scaffolding / bundle install, etc

echo -e "Great, you've got everything installed. Happy Coding." #Print logo