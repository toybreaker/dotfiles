## HOMEBREW AND GIT
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
```
brew analytics off
brew install git
brew install bash-completion
brew install yarn
```

### QUICKLOOK PLUGINS
from:
```https://sourabhbajaj.com/mac-setup/Homebrew/Cask.html```

```
brew cask install \
    qlcolorcode \
    qlstephen \
    qlmarkdown \
    quicklook-json \
    qlprettypatch \
    quicklook-csv \
    betterzip \
    webpquicklook \
    qlimagesize \
    suspicious-package
```

### USEFUL APPS

```
brew cask install \
    android-file-transfer \
    vlc \
    atom \
    github \
    diffmerge \
    pomotroid \
    cheatsheet \
    google-backup-and-sync \  
    brave-browser\
    libreoffice\  
    little-snitch\
    pomolectron\  
    firefox\
    appcleaner \
    google-chrome \
    responsively
```


from : https://www.netlify.com/blog/2016/06/07/setting-up-your-jamstack-from-scratch/

NVM allows you to install multiple versions of Node, specify which version you want to use, and change versions on the fly. Additionally with NVM, you don’t need to use sudo to install node modules globally.

To install or update nvm, you can use the install script using cURL:

```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
```


## RUBY

Make ```"/usr/local/var/log"``` writeable:

```
sudo chown -R $(whoami) /usr/local/var/log
```

Install ruby env manager

```
brew install rbenv ruby-install
```

Install openssl

```
brew instal openssl@1.1
```

## Shell

```
echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> /Users/admi/.bash_profile
```

## Install ruby

```
rbenv install 2.6.3
rbenv install 2.6.6
```

Define which ruby to use globally

```
rbenv global 2.6.6
```

If you run into problem try use this Doctor script:

```
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
```

Add these at the end of bash_profile

```
export RBENV_ROOT=/usr/local/var/rbenv
eval "$(rbenv init -)"
```

Reload you shell:

```
source ~/.bash_profile
```

Install bundler

```
gem install bundler
gem install rmagick -v '4.1.0

```

## MIX

```
yarn global add @vue/cli
```

```
npm install netlify-cli -g
```
