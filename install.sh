#!/bin/zsh

source include/shared_vars.sh

BREWED_TOOLS=(rbenv ruby-build libpqxx grc coreutils hub tree aspell --lang=en) #tools to install via Homebrew
PIP_TOOLS=(virtualenvwrapper) #tools to install via pip
RUBY_GEMS=(bundler hoe bundler foreman pg rails thin)
CASK_TOOLS=(google-chrome seil vlc)
BACKUP_DIR='' #where we will backup this instance of install

#install pip and friends
install_pip()
{
    if test ! $(which pip)
    then
        echo "     [-] There is no pip. Going to install pip. This will ask for your root password."
        sudo easy_install pip
    fi

    pip install --ignore-installed $PIP_TOOLS
}

#install Homebrew and friends
install_homebrew()
{
    #Install homebrew
    if test ! $(which brew)
    then
        echo "     [-] There is no Homebrew. Going to install Homebrew."
        ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
    fi

    #brew me some goodness
    brew update
    brew install $BREWED_TOOLS
}

#install CASK APPS
install_cask()
{
    #brew me some goodness
    brew tap caskroom/cask
    brew cask install $CASK_TOOLS
}

#install Ruby Gems
install_rubygems()
{
    #Install gems
    if test ! $(which gem)
    then
      echo "     [-] There is no Gem. You need to install Ruby. (brew install ruby)"
    else
      eval "$(rbenv init -)"
      rbenv install 2.3.0
      rbenv global 2.3.0
      gem update --system
      gem install $RUBY_GEMS --no-rdoc --no-ri
    fi
}

#install Janus
install_janus()
{
    vim_home=$HOME/.vim
    if [ ! -d $vim_home/janus ]
    then
        curl -Lo- https://bit.ly/janus-bootstrap | sh
    else
        #There must be a better way to do this! (like make -C)
        cd $vim_home
        rake default
        cd -
    fi
}

#install CLI font
install_cli_font()
{
    #Using Inconsolata http://www.levien.com/type/myfonts/inconsolata.html
    font_source=http://www.levien.com/type/myfonts/Inconsolata.otf
    font_target=$HOME_DIR/Library/Fonts/Inconsolata.otf

    if [ ! -f $font_target ]
    then
        curl -L $font_source -o $font_target
    fi
}

#create a backup directory
create_backup_dir()
{
    timestamp=`date "+%Y-%h-%d-%H-%M-%S"`
    backup_dir="$BACKUP_ROOT/$timestamp"
    mkdir -p $backup_dir
    if [ -d $backup_dir ]
    then
        BACKUP_DIR=$backup_dir
    else
        echo "     [x] Could not create backup directory $backup_dir"
        return 1
    fi
}

#backup a file
backup_file()
{
    backup_dir=$1/
    source_file=$2
    mv $source_file $backup_dir
}

#check dependencies and create backup directories
initialize()
{
    echo "     [+] Installing Homebrew and friends"
    install_homebrew
    echo "     [+] Installing pip and friends"
    install_pip
    echo "     [+] Installing Ruby Gems"
    install_rubygems
    echo "     [+] Installing Janus for vim"
    install_janus
    echo "     [+] Installing CLI font"
    install_cli_font
    echo "     [+] Installing Cask Apps"
    install_cask

    create_backup_dir
}

#install the dot files in $HOME_DIR
install_dotfiles()
{

    # glob *.SYMLINK_EXT from directories and create equivalent symlinks in $HOME_DIR
    for f in `find $PWD -name "*.$SYMLINK_EXT"`; do
        target=$HOME_DIR/.`basename -s .$SYMLINK_EXT $f`

        #if the target exists then back it up
        if [ -e $target ]
        then
            backup_file $BACKUP_DIR $target
        fi

       ln -s $f $target;
    done
}

#unleash the dots!
initialize
if [ $? -eq 0 ]
then
    install_dotfiles
    echo "     [+] dotfile installation complete"
    echo "     [+] Your old dot files are backed up in $BACKUP_DIR"
    echo "     [+] You can revert the changes with revert.sh"
else
    echo "     [x] There was an error initializing... will revert changes now"
    source revert.sh
    echo "     [x] Done."
fi
