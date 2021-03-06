160108 - El Capitan localhost setup
--
Step guide to install local development environment:

- adapted from [echo&co](https://echo.co/blog/os-x-1010-yosemite-local-development-environment-apache-php-and-mysql-homebrew)
- including fix from [homebrew](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/El_Capitan_and_Homebrew.md)
- and more...



### Homebrew Setup

Part of the OS X 10.11/El Capitan changes is something called System Integrity Protection or "SIP".

SIP prevents you from writing to many system directories such as /usr, /System & /bin, regardless of whether or not you are root. The Apple keynote is here if you'd like to learn more. As noted in the keynote, Apple is leaving /usr/local open for developers to use, so Homebrew can still be used as expected.

One of the implications of SIP was that you could not simply create /usr/local if you had removed it. This issue was fixed with the com.apple.pkg.SystemIntegrityProtectionConfig.14U2076 update.

```sh
sudo chown -R $(whoami):admin /usr/local
```

If you've not already familiar with Homebrew, check [http://brew.sh](http://brew.sh).
Before brew you need to install Command Line Tools for Xcode:

```sh
xcode-select --install
```
then can install brew with this:

```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

If you do not have git available on your system, either from Homebrew, Xcode, or another source, you can install it with Homebrew now (if you already have it installed, skip this step to keep the version of git you already have):

```sh
brew install -v git
brew install -v node
brew install -v wget
brew tap homebrew/versions
brew tap caskroom/cask
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefox
brew cask install opera
brew cask install atom
brew cask install google-drive
brew cask install openoffice
brew cask install versions
brew cask install macdown
brew cask install skype
brew cask install dropbox
brew cask install sublime-text
brew cask install vlc

```

After install softwares, move all apps from
`/opt/homebrew-cask/Caskroom/ ` to ` /Applications `.

And to remove all installations files from
`/Library/Caches/Homebrew `.

### Sublime Text 2
Let me use `subl` command to lauch Sublime from terminal:

```sh
ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
```

#MySQL
To match production server, check existing version:

```sh
brew info mysql
```
Search available versions

```sh
brew search mysql
```

Should output something like this:

```sh
|> brew search mysql
automysqlbackup                        mysql                                  mysql-sandbox                        
homebrew/php/php53-mysqlnd_ms          mysql++                                mysql-search-replace                 
homebrew/php/php54-mysqlnd_ms          mysql-cluster                          mysqltuner                           
homebrew/php/php55-mysqlnd_ms          mysql-connector-c                    
homebrew/php/php56-mysqlnd_ms          mysql-connector-c++                  
homebrew/versions/mysql51              homebrew/versions/mysql56              Caskroom/cask/mysqlworkbench         
homebrew/versions/mysql55              Caskroom/cask/mysql-utilities          Caskroom/cask/navicat-for-mysql  
```

### Install MySQL 5.5 with Homebrew

Note that since `brew tap homebrew/versions` is already tapped dont need `brew install -v homebrew/versions/mysql55`... This enough:

```sh
brew install -v mysql55
```


Copy the default my-default.cnf file to the MySQL Homebrew Cellar directory where it will be loaded on application start:

```sh
cp -v $(brew --prefix mysql55)/support-files/my-small.cnf $(brew --prefix)/etc/my.cnf
```

This will configure MySQL to allow for the maximum packet size, only appropriate for a local or development server. Also, we'll keep each InnoDB table in separate files to keep ibdataN-type file sizes low and make file-based backups, like Time Machine, easier to manage multiple small files instead of a few large InnoDB data files. This is the first of many multi-line single commands. The following is a single, multi-line command; copy and paste the entire block at once:

```sh
cat >> $(brew --prefix)/etc/my.cnf <<'EOF'

# junglestar.org changes
max_allowed_packet = 1073741824
innodb_file_per_table = 1
EOF
```
Uncomment the sample option for innodb_buffer_pool_size to improve performance:

```sh
sed -i '' 's/^#[[:space:]]*\(innodb_buffer_pool_size\)/\1/' $(brew --prefix)/etc/my.cnf
```
Now we need to start MySQL using OS X's launchd. This used to be an involved process with launchctl commands, but now we can leverage the excellent brew services command:

```sh
brew services start mysql55
```
By default, MySQL's root user has an empty password from any connection. You are advised to run mysql_secure_installation and at least set a password for the root user:

```sh
/usr/local/Cellar/mysql55/5.5.44/bin/mysql_secure_installation
```
#Apache

Start by stopping the built-in Apache, if it's running, and prevent it from starting on boot. This is one of very few times you'll need to use sudo:

```sh
sudo launchctl unload /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null
```
The formula for building Apache is not in the default Homebrew repository that you get by installing Homebrew. While we can use the format of brew install external-repo/formula, if an external formula relies on another external formula, you have to use the brew tap command first. I know, it's weird. So, we need to tap homebrew-dupes because "homebrew-apache/httpd22" relies on "homebrew-dupes/zlib". Whew:

```sh
brew tap homebrew/dupes
```
A slight deviation from my prior walkthroughs: we'll install Apache 2.2 with the event MPM and set up PHP-FPM instead of mod_php. If those terms mean anything to you and you're curious as to why I decided to go this route; it's because: 1) switching PHP versions is far easier with PHP-FPM and the default 9000 port instead of also editing the Apache configuration to switch the mod_php module location, and 2) if we're therefore not using mod_php, we don't have to use the prefork MPM and can get better performance with event or worker. As to why I'm using 2.2 instead of 2.4, popular FOSS projects like Drupal and WordPress still ship with 2.2-style .htaccess files. Using 2.4 sometimes means you have to set up "compat" modules, and that's above the requirement for a local environment, in my opinion.

Onward! Let's install Apache 2.2 with the event MPM, and we'll use Homebrew's OpenSSL library since it's more up-to-date than OS X's:

```sh
brew install -v homebrew/apache/httpd22 --with-brewed-openssl --with-mpm-event
```

In order to get Apache and PHP to communicate via PHP-FPM, we'll install the mod_fastcgi module:


```sh
brew install -v homebrew/apache/mod_fastcgi --with-brewed-httpd22
```
To prevent any potential problems with previous mod_fastcgi setups, let's remove all references to the mod_fastcgi module (we'll re-add the new version later):

```sh
sed -i '' '/fastcgi_module/d' $(brew --prefix)/etc/apache2/2.2/httpd.conf
```
Add the logic for Apache to send PHP to PHP-FPM with mod_fastcgi, and reference that we'll want to use the file ~/Sites/httpd-vhosts.conf to configure our VirtualHosts. The parenthesis are used to run the command in a subprocess, so that the exported variables don't persist in your terminal session afterwards. Also, you'll see export USERHOME a few times in this guide; I look up the full path for your user home directory from the operating system wherever a full path is needed in a configuration file and "~" or a literal "$HOME" would not work.

This is all one command, so copy and paste the entire code block at once:

```sh
(export USERHOME=$(dscl . -read /Users/`whoami` NFSHomeDirectory | awk -F"\: " '{print $2}') ; export MODFASTCGIPREFIX=$(brew --prefix mod_fastcgi) ; cat >> $(brew --prefix)/etc/apache2/2.4/httpd.conf <<EOF

# junglestar & org. changes

# Load PHP-FPM via mod_fastcgi
LoadModule fastcgi_module    ${MODFASTCGIPREFIX}/libexec/mod_fastcgi.so

<IfModule fastcgi_module>
  FastCgiConfig -maxClassProcesses 1 -idle-timeout 1500

  # Prevent accessing FastCGI alias paths directly
  <LocationMatch "^/fastcgi">
    <IfModule mod_authz_core.c>
      Require env REDIRECT_STATUS
    </IfModule>
    <IfModule !mod_authz_core.c>
      Order Deny,Allow
      Deny from All
      Allow from env=REDIRECT_STATUS
    </IfModule>
  </LocationMatch>

  FastCgiExternalServer /php-fpm -host 127.0.0.1:9000 -pass-header Authorization -idle-timeout 1500
  ScriptAlias /fastcgiphp /php-fpm
  Action php-fastcgi /fastcgiphp

  # Send PHP extensions to PHP-FPM
  AddHandler php-fastcgi .php

  # PHP options
  AddType text/html .php
  AddType application/x-httpd-php .php
  DirectoryIndex index.php index.html index.htm
</IfModule>

# Include our VirtualHosts
Include ${USERHOME}/Sites/httpd-vhosts.conf
EOF
)
```
We'll be using the file ~/Sites/httpd-vhosts.conf to configure our VirtualHosts, but the ~/Sites folder doesn't exist by default in newer versions of OS X. We'll also create folders for logs and SSL files:


```sh
mkdir -pv ~/Sites/{logs,ssl}
```
Let's populate the ~/Sites/httpd-vhosts.conf file. The biggest difference from my previous guides are that you'll see the port numbers are 8080/8443 instead of 80/443. OS X 10.9 and earlier had the ipfw firewall which allowed for port redirecting, so we would send port 80 traffic "directly" to our Apache. But ipfw is now removed and replaced by pf which "forwards" traffic to another port. We'll get to that later, but know that "8080" and "8443" are not typos but are acceptable because of later port forwarding. Also, I've now added a basic SSL configuration (though you'll need to acknowledge warnings in your browser about self-signed certificates):

```sh
touch ~/Sites/httpd-vhosts.conf

(export USERHOME=$(dscl . -read /Users/`whoami` NFSHomeDirectory | awk -F"\: " '{print $2}') ; cat > ~/Sites/httpd-vhosts.conf <<EOF
#
# Listening ports.
#
#Listen 8080  # defined in main httpd.conf
Listen 8443

#
# Use name-based virtual hosting.
#
NameVirtualHost *:8080
NameVirtualHost *:8443

#
# Set up permissions for VirtualHosts in ~/Sites
#
<Directory "${USERHOME}/Sites">
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    <IfModule mod_authz_core.c>
        Require all granted
    </IfModule>
    <IfModule !mod_authz_core.c>
        Order allow,deny
        Allow from all
    </IfModule>
</Directory>

# For http://localhost in the users' Sites folder
<VirtualHost _default_:8080>
    ServerName localhost
    DocumentRoot "${USERHOME}/Sites"
</VirtualHost>
<VirtualHost _default_:8443>
    ServerName localhost
    Include "${USERHOME}/Sites/ssl/ssl-shared-cert.inc"
    DocumentRoot "${USERHOME}/Sites"
</VirtualHost>

#
# VirtualHosts
#

## Manual VirtualHost template for HTTP and HTTPS
#<VirtualHost *:8080>
#  ServerName project.dev
#  CustomLog "${USERHOME}/Sites/logs/project.dev-access_log" combined
#  ErrorLog "${USERHOME}/Sites/logs/project.dev-error_log"
#  DocumentRoot "${USERHOME}/Sites/project.dev"
#</VirtualHost>
#<VirtualHost *:8443>
#  ServerName project.dev
#  Include "${USERHOME}/Sites/ssl/ssl-shared-cert.inc"
#  CustomLog "${USERHOME}/Sites/logs/project.dev-access_log" combined
#  ErrorLog "${USERHOME}/Sites/logs/project.dev-error_log"
#  DocumentRoot "${USERHOME}/Sites/project.dev"
#</VirtualHost>

#
# Automatic VirtualHosts
#
# A directory at ${USERHOME}/Sites/webroot can be accessed at http://webroot.dev
# In Drupal, uncomment the line with: RewriteBase /
#

# This log format will display the per-virtual-host as the first field followed by a typical log line
LogFormat "%V %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combinedmassvhost

# Auto-VirtualHosts with .dev
<VirtualHost *:8080>
  ServerName dev
  ServerAlias *.dev

  CustomLog "${USERHOME}/Sites/logs/dev-access_log" combinedmassvhost
  ErrorLog "${USERHOME}/Sites/logs/dev-error_log"

  VirtualDocumentRoot ${USERHOME}/Sites/%-2+
</VirtualHost>
<VirtualHost *:8443>
  ServerName dev
  ServerAlias *.dev
  Include "${USERHOME}/Sites/ssl/ssl-shared-cert.inc"

  CustomLog "${USERHOME}/Sites/logs/dev-access_log" combinedmassvhost
  ErrorLog "${USERHOME}/Sites/logs/dev-error_log"

  VirtualDocumentRoot ${USERHOME}/Sites/%-2+
</VirtualHost>
EOF
)
```

You may have noticed that ~/Sites/ssl/ssl-shared-cert.inc is included multiple times; create that file and the SSL files it needs:

```sh
(export USERHOME=$(dscl . -read /Users/`whoami` NFSHomeDirectory | awk -F"\: " '{print $2}') ; cat > ~/Sites/ssl/ssl-shared-cert.inc <<EOF
SSLEngine On
SSLProtocol all -SSLv2 -SSLv3
SSLCipherSuite ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW
SSLCertificateFile "${USERHOME}/Sites/ssl/selfsigned.crt"
SSLCertificateKeyFile "${USERHOME}/Sites/ssl/private.key"
EOF
)
```

#START APACHE

Start Homebrew's Apache and set to start on login:

```sh
brew services start httpd22
```

#RUN WITH PORT 80
You may notice that httpd.conf is running Apache on ports 8080 and 8443. Manually adding ":8080" each time you're referencing your dev sites is no fun, but running Apache on port 80 requires root. The next two commands will create and load a firewall rule to forward port 80 requests to 8080, and port 443 requests to 8443. The end result is that we don't need to add the port number when visiting a project dev site, like "http://projectname.dev/" instead of "http://projectname.dev:8080/".

The following command will create the file /Library/LaunchDaemons/co.echo.httpdfwd.plist as root, and owned by root, since it needs elevated privileges:



```sh
sudo bash -c 'export TAB=$'"'"'\t'"'"'
cat > /Library/LaunchDaemons/org.junglestar.httpdfwd.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
${TAB}<key>Label</key>
${TAB}<string>org.junglestar.httpdfwd</string>
${TAB}<key>ProgramArguments</key>
${TAB}<array>
${TAB}${TAB}<string>sh</string>
${TAB}${TAB}<string>-c</string>
${TAB}${TAB}<string>echo "rdr pass proto tcp from any to any port {80,8080} -> 127.0.0.1 port 8080" | pfctl -a "com.apple/260.HttpFwdFirewall" -Ef - &amp;&amp; echo "rdr pass proto tcp from any to any port {443,8443} -> 127.0.0.1 port 8443" | pfctl -a "com.apple/261.HttpFwdFirewall" -Ef - &amp;&amp; sysctl -w net.inet.ip.forwarding=1</string>
${TAB}</array>
${TAB}<key>RunAtLoad</key>
${TAB}<true/>
${TAB}<key>UserName</key>
${TAB}<string>root</string>
</dict>
</plist>
EOF'
```
This file will be loaded on login and set up the 80->8080 and 443->8443 port forwards, but we can load it manually now so we don't need to log out and back in:

```sh
sudo launchctl load -Fw /Library/LaunchDaemons/org.junglestar.httpdfwd.plist
```

#PHP

This is for PHP, version 5.5. If you'd like to use 5.6, 5.4, simply change the "5.5" and "php55" values below appropriately.

```sh
brew install -v homebrew/php/php55
```

Set timezone and change other PHP settings (sudo is needed here to get the current timezone on OS X) to be more developer-friendly, and add a PHP error log (without this, you may get Internal Server Errors if PHP has errors to write and no logs to write to):

```sh
(export USERHOME=$(dscl . -read /Users/`whoami` NFSHomeDirectory | awk -F"\: " '{print $2}') ; sed -i '-default' -e 's|^;\(date\.timezone[[:space:]]*=\).*|\1 \"'$(sudo systemsetup -gettimezone|awk -F"\: " '{print $2}')'\"|; s|^\(memory_limit[[:space:]]*=\).*|\1 512M|; s|^\(post_max_size[[:space:]]*=\).*|\1 200M|; s|^\(upload_max_filesize[[:space:]]*=\).*|\1 100M|; s|^\(default_socket_timeout[[:space:]]*=\).*|\1 600|; s|^\(max_execution_time[[:space:]]*=\).*|\1 300|; s|^\(max_input_time[[:space:]]*=\).*|\1 600|; $a\'$'\n''\'$'\n''; PHP Error log\'$'\n''error_log = '$USERHOME'/Sites/logs/php-error_log'$'\n' $(brew --prefix)/etc/php/5.5/php.ini)
```

Fix a pear and pecl permissions problem:

```sh
chmod -R ug+w $(brew --prefix php55)/lib/php
```


```sh
brew install -v php55-opcache
```

```sh
/usr/bin/sed -i '' "s|^\(\;\)\{0,1\}[[:space:]]*\(opcache\.enable[[:space:]]*=[[:space:]]*\)0|\21|; s|^;\(opcache\.memory_consumption[[:space:]]*=[[:space:]]*\)[0-9]*|\1256|;" $(brew --prefix)/etc/php/5.5/php.ini
```


Finally, let's start PHP-FPM:

```sh
brew services start php55
```

Optional: At this point, if you want to switch between PHP versions, you'd want to: brew services stop php55 && brew unlink php55 && brew link php54 && brew services start php54. No need to touch the Apache configuration at all!



#DNSMasq

A difference now between what I've shown before, is that we don't have to run on port 53 or run dnsmasq as root. The end result here is that any DNS request ending in .dev reply with the IP address 127.0.0.1:

```sh
brew install -v dnsmasq
```

```sh
echo 'address=/.dev/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf
```

```sh
echo 'listen-address=127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf
```

```sh
echo 'port=35353' >> $(brew --prefix)/etc/dnsmasq.conf
```

Similar to how we run Apache and PHP-FPM, we'll start DNSMasq:

```sh
brew services start dnsmasq
```


With DNSMasq running, configure OS X to use your local host for DNS queries ending in .dev:

```sh
sudo mkdir -v /etc/resolver
```

```sh
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
```
```sh
sudo bash -c 'echo "port 35353" >> /etc/resolver/dev'
```

To test, the command `ping -c 3 jungle.dev` should return results from 127.0.0.1. If it doesn't work right away, try turning WiFi off and on (or unplug/plug your ethernet cable), or reboot your system.

```sh
ping -c 3 jungle.dev
```

works?

yes, after restart!

### BUT BIG BUT…
rokma.dev nor others are working

--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--






from [mateusortiz]( https://gist.github.com/mateusortiz/0f2f8f38284700ae2d0b)

Disable the sound effects on boot

```sh
sudo nvram SystemAudioVolume=" "
```

```sh
brew cask install skype
```

```sh
brew cask install dropbox
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
