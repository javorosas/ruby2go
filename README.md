ruby2go
=======

Easily set up your ruby dev environment on GNU/Linux.

## Considerations
This tool is scoped for fresh ruby developers.

## Project stages
| Done | Stage |                           Description                           | Planned date | Released |
|------|-------|-----------------------------------------------------------------|--------------|----------|
| X    |     1 | Bash script to install ruby+rails                               | 2013/jan/11  |          |
|      |     2 | Same script asks the user whether to install ruby or ruby+rails | 2013/jan/18  |          |
|      |     3 | Generate "hello world" scaffolding when finished                |              |          |
|      |     4 | Client-side web app that generates custom script                |              |          |
|      |     5 | Same app generates rpm/deb package                              |              |          |

## Installation list
NOTE: package manager's install command is replaced with the generic word 'pack'
    
    pack git
    pack curl
    pack build-essential

    # rvm requirements
    pack zlib1g-dev
    pack libyaml-dev
    pack libsqlite3-dev

    pack nodejs

    curl -L get.rvm.io | bash -s stable

    source $HOME/.rvm/scripts/rvm


    rvm pkg install openssl
    rvm install 1.9.3 –with-openssl-dir=$HOME/.rvm/usr

    gem install rails

    rvm use 1.9.3 –default
    gem install execjs

    # TODO: Generate scaffolding / bundle install, etc