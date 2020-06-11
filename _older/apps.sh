#!/bin/sh
# NOT YET EXECUTABLE, still a step guide...

brew install -v git
brew install -v wget
brew install -v node

brew install imagemagick

brew tap homebrew/versions

# Node packages are managed by npm which comes with Node. Install these globally:
npm install -g bower jshint svgo gulp grunt imagemin-pngquant phantomjs browser-sync


# stuff for manilupating images
brew install homebrew/science/vips
brew install vips --with-webp --with-graphicsmagick --without-check


# We manage Ruby versions through rbenv which is also distributed through Homebrew. Install it by running:
brew install rbenv


# copy to .bash_profile:

# brew install ruby rbenv, to use Homebrew's directories rather than ~/.rbenv
export RBENV_ROOT=/usr/local/var/rbenv

# To enable shims and autocompletion
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi


# Install Ruby
# To install ruby versions and gems we first need to add the ruby-build dependency by running:
brew install ruby-build

# Then we can run rbenv install -l to list all available versions of ruby. Currently the latest stable version is 2.2.2 so we run
rbenv install 2.2.2

# Then we need to set this version as the new global default so it is used without having to configure something. This installation might take a while. After it has successfully finished run
rbenv global 2.2.2

# to use the just installed version as global default. Finish up your installation by running:
rbenv rehash

# This command is needed after you install a new version of Ruby, or install a gem that provides commands.


# Gems
# Ruby provides many software packages in gems. To make sure these run nicely and without problems update the rubygems package by running:

gem update --system

gem install kramdown
