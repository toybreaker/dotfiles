Configuring The Trackpad
To make the trackpad behave correctly, ensure that these settings are enabled:

System Preferences > Trackpad > Tap to click
System Preferences > Accessibility > Mouse & Trackpad > Trackpad Options… > Enable dragging

Securing the Safari Browser
Whether or not you regularly use Safari, you should open it once, and adjust the settings in case that you use it later.

First, choose Safari > Preferences > General and deselect the option Open “safe” files after downloading.

Second, go to Safari > Preferences > Search. Decide which search engine that you want to use. Ensure that Safari Suggestions is not enabled.

Then, check the plug-in settings. Go to Safari > Preferences > Security > Plug-in Settings… and review the plug-ins and settings.

Configuring Security
Apple provide quite secure operating systems, but unfortunately convenience has won out over security in a few places. These can easily be corrected by changing a few settings. If you are using a laptop then you should probably make all of these changes as soon as possible.

Basic Settings
Select System Preferences > Security & Privacy, and set the following:

Under General, set require a password after sleep or screen saver begins to immediately
Click Advanced… and select Require an administrator password to access system-wide preferences
Under Firewall, click Turn Firewall On.
Under Privacy, select Analytics and ensure that the options are not enabled.

Disable Spotlight
By default, Spotlight sends queries to Apple. Unless you want this feature, turn it off.

Select System Preferences > Spotlight > Search Results, and ensure that Spotlight Suggestions is not enabled.


Enable File Vault NOW
Current versions of macOS include File Vault 2, a full-disk encryption system that has little in common with the much more limited File Vault 1. You should enable File Vault NOW, because it is the only protection against anyone with physical access to your computer. All other security measures will be completely bypassed if someone with physical access simply restarts the computer with a bootable pen drive.

File Vault really is secure, which means that you can permanently lose access to your data if you lose the passwords and the recovery key.

Set a Firmware Password
Set a password to stop access to the Recovery mode. Otherwise, any malicious individual can change the firmware settings to boot from a disc or device of their choosing. If you did not enable File Vault, then the attacker will have complete access to all of the files on the system.

Apple Knowledge Base article HT204455 provides full details:
https://support.apple.com/en-gb/HT204455




# MacOS fine tuning
--

from [mateusortiz]( https://gist.github.com/mateusortiz/0f2f8f38284700ae2d0b)

Disable the sound effects on boot

```sh
sudo nvram SystemAudioVolume=" "
```



Disable the warning when changing a file extension

```sh
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
```

Finder: allow text selection in Quick Look

```sh
defaults write com.apple.finder QLEnableTextSelection -bool true
```

Save screenshots to the Pictures


```sh
defaults write com.apple.screencapture location -string "$HOME/Pictures"
```

Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
```sh
defaults write com.apple.screencapture type -string "png"
```

Disable shadow in screenshots

```sh
defaults write com.apple.screencapture disable-shadow -bool true
```

Use plain text mode for new TextEdit documents

```sh
defaults write com.apple.TextEdit RichText -int 0
```

Prevent Time Machine from prompting to use new hard drives as backup volume

```sh
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
```

### Spotlight                                                                   

(Hide Spotlight tray-icon and subsequent helper)
use `sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search`

Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before.)
(Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.)

```sh
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
```

Change indexing order and disable some file types

```sh
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
```


Load new settings before rebuilding the index (note: didnt worked!)

```sh
killall mds
```



Make sure indexing is enabled for the main volume

```sh
sudo mdutil -i on /
```

Rebuild the index from scratch (still to be done!)

```sh
sudo mdutil -E /
```

Disable Sudden Motion Sensor, Leaving this turned on is useless when you're using SSDs.

```sh
sudo pmset -a sms 0
```


Show Full Path in Finder Title

```sh
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
```

Expand Save Panel by Default

```sh
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true && \
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
```


Path Bar: Show

```sh
defaults write com.apple.finder ShowPathbar -bool true
```

Status Bar: Show

```sh
defaults write com.apple.finder ShowStatusBar -bool true
```

Avoids creation of .DS_Store and AppleDouble files on network disks.

```sh
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
```

Avoids creation of .DS_Store and AppleDouble files on USBs.

```sh
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
```


Play iOS charging sound when MagSafe is connected.

```sh
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true && \
open /System/Library/CoreServices/PowerChime.app
```








#!/usr/bin/env bash

# Install command-line tools using Homebrew.

#Install brew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

#Test:

brew doctor

#The following directories should be writable by your user:

/usr/local/var/log

#Get the ownership:

sudo chown -R $(whoami) /usr/local/var/log






#Install some basic stuff

brew install -v git
brew install -v node
brew install -v yarn
brew install -v wget
brew install -v imagemagick

brew cask install virtualbox
brew cask install macdown