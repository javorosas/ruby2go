#!/bin/bash
# Nearsoft, Inc.
# Nearsoft Labs

#####################################################
#####################################################
case $OSTYPE in
        darwin*)
                # I'm a Mac!
                os="mac"
        ;;
        linux-gnu)
                # I'm linux!
                os="linux"
        ;;
esac


function installGems() {
    echo "Installing gems $gems" 
    sudo gem install $1
}

function toLower() {
    echo $1 | tr "[:upper:]" "[:lower:]"
}

# Execute getopt on the arguments passed to this program, identified by the special character $@
PARSED_OPTIONS=$(getopt -n "$0"  -o hr:l:nxg: --long "help,ruby:,rails:,no-gems,vim,gvim,qvim,vim-plugins,emacs,no-example,gem"  -- "$@")
 
#Bad arguments, something has gone wrong with the getopt command.
if [ $? -ne 0 ];
then
    exit 1
fi
 
# A little magic, necessary when using getopt.
eval set -- "$PARSED_OPTIONS"
 
install_example=false
ruby_v=1.9.3 # default ruby version

# Now goes through all the options with a case and using shift to analyse 1 argument at a time.
#$1 identifies the first argument, and when we use shift we discard the first argument, so $2 becomes $1 and goes again through the case.
while true;
do
    case "$1" in
        -h|--help)
            echo "Usage $0 -r or $0 --ruby"
            exit 1
            shift;; 

        -r|--ruby)
            # We need to take the option of the argument "ruby"
            if [ -n "$2" ];
            then
                ruby_v=$2
                # echo "Using Ruby $2"
            fi
            shift 2;;

        -l|--rails)
            if [ -n "$2" ];
            then
                rails_v=$2
                # echo "Using Rails $2"
            fi
            shift 2;;

        -n|--no-gems)
                gems=false
            shift;;
        -x|--example)
                install_example=true
            shift;;
        -g|--gem)
            if [ -n "$2" ]; then
                gems="$gems $2"
            fi
            shift 2;;
        --)
            shift
            break;;
    esac
done


#######################################################3
#######################################################3


# Make sure this script is not being executed as root
if [ "$(id -u)" == "0" ]; then
   echo "Don't run this script as root." 1>&2
   exit 1
fi

echo -e "\e[1;37mWelcome to Ruby2Go: The best way to install Ruby.\e[0m"    #Print logo

if [ $os == "linux" ]; then
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

elif [ $os == "mac" ]; then
    # TODO: Explain user what are we doing
    # Install RVM
    bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)

    # Load RVM to shell session/
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

fi
# TODO: Generate scaffolding / bundle install, etc
 
rvm install $ruby_v --with-openssl-dir=$HOME/.rvm/usr
rvm use $ruby_v --default

rails=`toLower $rails`

gems="execjs $gems"
if [[ $rails != "no" ]]; then
    gems="rails $gems"
fi

installGems $gems

echo -e "Great, you've got everything installed. Happy Coding." #Print logo
