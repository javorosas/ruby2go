ruby2go
=======

Easily set up your ruby dev environment on GNU/Linux and Mac.

# Basic installation
To install Ruby + Rails environment, open your terminal and type the following:
	
	mkdir ruby2go
	cd ruby2go
	wget https://bitbucket.org/nslabs/ruby2go/downloads/ruby2go
	sudo chmod +x ruby2go
	./ruby2go

# Configure your installation
You can either execute this script as shown above to install the most common packages for your environment, or customize your installation typing the following options

	Usage: ./ruby2go [options [argument]...]
	i.e.:  ./ruby2go --ruby 1.9.3 --gem devise --gem pg

	Options:
	 -g, --gem GEM          Installs the specified gem at the end of the script
	 -h, --help             Show this help text
	 -n, --no-gems          Do not install any gem (nor rails)
	 -R, --rails VERSION    Specify what version of Rails will be installed
	 -r, --ruby VERSION     Specify what version of ruby will be installed
	 -s, --sample           Download the sample app when installation is complete

Welcome aboard and happy coding!