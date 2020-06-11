Setup Mac OS X
=========================================

Setup set to not suffer the next time.
Thanks to [mateusortiz](https://gist.github.com/mateusortiz/0f2f8f38284700ae2d0b), [millermedeiros](https://gist.github.com/millermedeiros/6615994) and others...

Setup
-----

### 1. Run software update

Make sure everything is up to date.


### 2. Install Xcode and/or "Command Line Tools"



1. Xcode can be found on App Store. **preferred**
2. Open and accept the terms

3. Finaly got to the terminal and install "Command Line Tools"":

```sh
xcode-select --install
```

More info on [how to download Command Line Tools inside XCode can be found on StackOverflow](http://stackoverflow.com/questions/9329243/xcode-4-4-and-later-install-command-line-tools)


### 3. Install Dotfiles

I have an repo with my Dotfiles and instructions.

This will install some useful stuff and install Homebrew.


### 4. Install softwares


#### homebrew-cask

Many softwares can be installed through
[homebrew-cask](https://github.com/phinze/homebrew-cask) which makes the process way simpler:

  ```sh
  #!/bin/sh

  # homebrew-cask
  brew tap caskroom/cask
  brew cask install google-chrome
  brew cask install firefox
  brew cask install opera
  brew cask install qlmarkdown
  brew cask install atom
  brew cask install google-drive
  brew cask install openoffice
  brew cask install versions
  brew cask install macdown
  brew cask install skype
  brew cask install dropbox
  brew cask install sublime-text
  ```

After install softwares, move all apps from `/opt/homebrew-cask/Caskroom/` to `/Applications`. And to remove all installations files from `/Library/Caches/Homebrew`.

### What's included?

##### Browser

* [Chrome](https://www.google.com/intl/en/chrome/browser/)

* [Firefox](https://www.mozilla.org/en-US/firefox/products/)
* [Opera]()

##### Development

* [atom](https://atom.io/) GitFriendly editor
* [espresso](http://macrabbit.com/espresso/) WorkspaceFriendly editor

##### Others

* [macdown]() Markdown editor
* [Skype](http://www.skype.com/en/) Calls
* [Dropbox](https://www.dropbox.com) File syncing

As not everything is perfect, some apps aren't available through [homebrew-cask](https://github.com/caskroom/homebrew-cask) so you need to install it **manually**.


#### Manually
 - [Chrome Canary](https://www.google.com/chrome/browser/canary.html)
 - [Firefox developer edition](https://www.mozilla.org/en-US/firefox/channel/#developer)
 - [Chrome Canary](https://www.google.com/intl/en/chrome/browser/canary.html) ([how to set canary as default browser](http://aaltonen.co/2011/05/06/make-chrome-canary-the-default-browser-on-mac-os-x/))
 - [ScreenFlow]() for screencast recording
 - [LICEcap](http://www.cockos.com/licecap/) for GIF recording

### 5. Tweak a few OSX settings

from [saetia](https://gist.github.com/saetia/1623487/88bb6766048133d2a68403d02531ce62c46ad404):


Set hostname

```sh
sudo scutil --set HostName Bomboclat
```

from [mathiasbynens dotfiles](https://github.com/mathiasbynens/dotfiles):

```sh
###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Menu bar: show remaining battery time (on pre-10.8); hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "NO"
defaults write com.apple.menuextra.battery ShowTime -string "YES"


###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

#Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

#Show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

#Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

#Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

#Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

#Disable the Ping sidebar in iTunes
defaults write com.apple.iTunes disablePingSidebar -bool true

#Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist


###############################################################################
# Screen                                                                      #
###############################################################################

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true


###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# Spotlight                                                                   #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some file types
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "DIRECTORIES";}' \
  '{"enabled" = 1;"name" = "PDF";}' \
  '{"enabled" = 1;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}'
# Load new settings before rebuilding the index (with sudo cos ElCapitan complains)
sudo killall mds
# Make sure indexing is enabled for the main volume
sudo mdutil -i on /
# Rebuild the index from scratch
sudo mdutil -E /

# Set highlight color to green
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
```

source:https://github.com/mathiasbynens/dotfiles/blob/master/.osx

more here:https://gist.github.com/saetia/1623487


### 6. Create/Update `~/.bash_profile`

```sh
export PS1='\w \$ '

set -o vi

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

alias gvim="/Applications/MacVim.app/Contents/MacOS/Vim -g"
alias g="gvim --remote-silent"
alias cask="brew cask"

# https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
if [ -f ~/.bash/git-completion.sh ]; then
    source ~/.bash/git-completion.sh
fi

# `npm completion > ~/.bash/npm-completion.bash`
if [ -f ~/.bash/npm-completion.sh ]; then
    source ~/.bash/npm-completion.sh
fi

# borrowed from http://petdance.com/2013/04/my-bash-prompt-with-gitsvn-branchstatus-display/
if [ -f ~/.bash/prompt.sh ]; then
    source ~/.bash/prompt.sh
fi

. `brew --prefix`/etc/profile.d/z.sh
```


###  7. Create/Update `~/.gitconfig`

```gitconfig
; I removed the [user] block on purpose so other people don't copy it by mistake
; you will need to set these values
[apply]
    whitespace = fix
[color]
    ui = auto
[color "branch"]
    current = yellow reverse
    local = yellow
    remote = green
[color "diff"]
    meta = yellow bold
    frag = magenta bold
    old = red bold
    new = green bold
[color "status"]
    added = yellow
    changed = green
    untracked = cyan
[merge]
    log = true
[push]
    ; "simple" avoid headaches, specially if you use `--force` w/o specifying branch
    ; see: http://stackoverflow.com/questions/13148066/warning-push-default-is-unset-its-implicit-value-is-changing-in-git-2-0
    default = simple
[url "git://github.com/"]
    insteadOf = "github:"
[url "git@github.com:"]
    insteadOf = "gh:"
    pushInsteadOf = "github:"
    pushInsteadOf = "git://github.com/"
[url "git@github.com:millermedeiros/"]
    insteadOf = "mm:"
[url "git@github.com:mout/"]
    insteadOf = "mout:"
[core]
    excludesfile = ~/.gitignore_global
    ; setting the editor fixes git commit bug http://tooky.co.uk/2010/04/08/there-was-a-problem-with-the-editor-vi-git-on-mac-os-x.html
    editor = /usr/bin/vim
[alias]
    ; show merge tree + commits info
    graph = log --graph --date-order -C -M --pretty=format:\"<%h> %ad [%an] %Cgreen%d%Creset %s\" --all --date=short
    lg = log --graph --pretty=format:'%Cred%h%Creset %C(yellow)%an%d%Creset %s %Cgreen(%cr)%Creset' --date=relative
    ; basic logging for quick browsing
    ls = log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cgreen\\ [%cn]" --decorate
    ll = log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cgreen\\ [%cn]" --decorate --numstat
    ; log + file diff
    fl = log -u
    ; find paths that matches the string
    f = "!git ls-files | grep -i"
    ; delete all merged branches
    ; dm = !git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
    ; shortcuts
    cp = cherry-pick
    st = status -s
    cl = clone
    ci = commit
    co = checkout
    br = branch
    dc = diff --cached
```

You will need to set the user name and email (removed from .gitconfig to avoid
errors):

```sh
git config --global user.name "Your Name Here"
git config --global user.email youremail@example.com
```



### 8. Config vim

I keep [my settings](https://gist.github.com/millermedeiros/1262085) and
bundles on dropbox, just need to create the symlinks.

```sh
# symlink DropBox files
ln -s ~/Dropbox/vim/vim ~/.vim
ln -s ~/Dropbox/vim/vimrc ~/.vimrc
ln -s ~/Dropbox/vim/gvimrc ~/.gvimrc
```

Might change this in the future to use a git repository tho.



### 9. Configure npm and generate SSH keys for github

Need to set the npm user:

```sh
npm adduser
```

And also [generate SSH keys for github](https://help.github.com/articles/generating-ssh-keys)



### 10. Copy stuff from old HD

```sh
# recursively copy files and folders
# beware of rsync `-C, --cvs-exclude` flag since it might exclude files you
# don't want to like *.exe, core, tags...
rsync -av '/Volumes/Macintosh HD/Users/millermedeiros/Projects' ~/tmp_projects
rsync -av '/Volumes/Macintosh HD/Users/millermedeiros/Music/iTunes/iTunes Media' ~/tmp_music
```

Check if files were copied properly and rename/move. Copying to a temporary
folder since `rsync` might delete files depending on the options and/or merge
folders that you do not want to merge.

`rsync` is great, you should use it when possible.


### 11. Download IE test VMs for VirtualBox

these take a while to download! so maybe do it on a separate day as a
background process...

http://www.modern.ie/en-us/virtualization-tools

```sh
# IE8 XP
curl -O "https://az412801.vo.msecnd.net/vhd/IEKitV1_Final/VirtualBox/OSX/IE8_XP/IE8.XP.For.MacVirtualBox.ova"

# IE9 Win7
curl -O "https://az412801.vo.msecnd.net/vhd/IEKitV1_Final/VirtualBox/OSX/IE9_Win7/IE9.Win7.For.MacVirtualBox.part{1.sfx,2.rar,3.rar,4.rar,5.rar}"

# IE10 Win8
curl -O "https://az412801.vo.msecnd.net/vhd/IEKitV1_Final/VirtualBox/OSX/IE10_Win8/IE10.Win8.For.MacVirtualBox.part{1.sfx,2.rar,3.rar}"
```


### 12. Download a base Ubuntu box for Vagrant

I'm using [Vagrant](http://www.vagrantup.com/) to setup a few VMs locally for
development.

The Ubuntu image takes ~2h to download since vagrant server is slow (~50Kb/s),
might be faster to download the iso from the [Ubuntu
site](http://www.ubuntu.com/download/server) and mount the image by yourself.

```sh
# Ubuntu 12.04 LTS 64-bits
vagrant box add precise64 http://files.vagrantup.com/precise64.box
```


### 13. Profit!


need more? [check](https://github.com/herrbischoff/awesome-osx-command-line)
