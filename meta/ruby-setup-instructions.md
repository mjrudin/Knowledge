# Ruby Installation Instructions

These directions are for OS X Mountain Lion

* Install XCode
    * Go to App Store
    * Search XCode
    * Install.
* Install Apple Command Line Tools
    * Open XCode
    * Go to Preferences > Downloads
    * Click Command Line Tools and install
* Install Macports (http://www.macports.org/install.php)
    * Download the Mountain Lion .pkg installer
    * Run the installer.
* Install apple-gcc42
    * In the terminal run `port install apple-gcc42`
* Install rvm
    * In the terminal run `curl -L https://get.rvm.io | bash -s stable`
* Install Ruby v1.9.3
    * In the terminal, run:
    * `rvm install 1.9.3 --with-gcc=/opt/local/bin/gcc-apple-4.2`
    * `rvm use 1.9.3`
