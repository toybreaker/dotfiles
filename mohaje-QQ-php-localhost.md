# USING SYS APACHE & PHP


from:
```
https://freecodetutorial.com/install-apache-mysql-php-macos-mojave-symfony-4-project/```

Start Apache

```
sudo apachectl start
```

Create a username.conf file which will help in configuring our document root.

```cd /etc/apache2/users/```

To know you username:

```whoami```

Make your_user_name.conf

```sudo atom admi.conf```

Paste this:

```
<Directory "/Users/admi/Sites/">
AllowOverride All
Options Indexes MultiViews FollowSymLinks
Require all granted
</Directory>
```

Save!

### Get the permissions right

```
sudo chmod 644 admi.conf
```

### Configure the httpd.conf file   
Type the following command in the terminal and go to apache2 directory.

```
cd /etc/apache2/
```

Inside this directory we have the ```httpd.conf``` file.
Make a backup copy of the httpd.conf before we change it.

```
sudo cp httpd.conf httpd.conf.backup
```

### Edit httpd.conf

```
sudo atom httpd.conf
```

Uncomment the following lines removing # from the start of each line.

```
LoadModule authz_core_module libexec/apache2/mod_authz_core.so
LoadModule authz_host_module libexec/apache2/mod_authz_host.so
LoadModule userdir_module libexec/apache2/mod_userdir.so
LoadModule include_module libexec/apache2/mod_include.so
LoadModule rewrite_module libexec/apache2/mod_rewrite.so
LoadModule php7_module libexec/apache2/libphp7.so
Include /private/etc/apache2/extra/httpd-userdir.conf
```

### Now change the following two lines below the commented lines.

```
#DocumentRoot "/Library/WebServer/Documents"
#<Directory "/Library/WebServer/Documents">
```
```
DocumentRoot "/Users/admi/Sites/"
<Directory "/Users/admi/Sites/">
    Options FollowSymLinks Multiviews
    MultiviewsMatch Any
    AllowOverride All
    Require all granted
</Directory>
```

### Set the server name

```
ServerName localhost
```

### Configure the httpd-userdir.conf file

```
cd /etc/apache2/extra/
```

Make a backup copy first

```
sudo cp httpd-userdir.conf httpd-userdir.conf.backup
```

Open to edit

```
sudo atom httpd-userdir.conf
```

Uncomment the following line.

```
Include /private/etc/apache2/users/*.conf
```

### Restart Apache

```
sudo apachectl restart
```

Allow the vhosts configuration from the Apache configuration file httpd.conf

### Open the httpd.conf

```
sudo atom /etc/apache2/httpd.conf
```

Search for ```vhosts``` and uncomment the include line

```
Include /private/etc/apache2/extra/httpd-vhosts.conf
```

### Edit the vhosts.conf file
Open this file to add in the virtual host.

```
sudo atom /etc/apache2/extra/httpd-vhosts.conf
```

Add the existing text block and edit to suit: (The first VirtualHost section is used for all requests that do not match a ServerName or ServerAlias in any <VirtualHost> block.)

```
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot "/Users/admi/Sites/"
    ErrorLog "/Users/admi/Sites/localhost.local-error_log"
    CustomLog "/Users/admi/Sites/localhost.local-error_log" common
    ServerAdmin me@rokma.com
</VirtualHost>
```

### Add the existing LIVE PROJECTS

```
<VirtualHost *:80>
 ServerName fumes.11ty.test
 CustomLog "/Users/admi/Sites/_logs/project.test-access_log" combined
 ErrorLog "/Users/admi/Sites/_logs/project.test-error_log"
 DocumentRoot "/Users/admi/Sites/fumes.11ty/_site/"
</VirtualHost>

<VirtualHost *:80>
 ServerName live-essences.test
 CustomLog "/Users/admi/Sites/_logs/project.test-access_log" combined
 ErrorLog "/Users/admi/Sites/_logs/project.test-error_log"
 DocumentRoot "/Users/admi/Sites/live-essences/_site/"
</VirtualHost>
```


Map the IP address to localhost

```
sudo atom /etc/hosts
```

Add the Domain and ‘www‘ alias to resolve to the localhost address.

```
127.0.0.1 adriasartore 
```
(....and all other local projects!! or install DNSmasq (see section later in this file)


Ensure your web directory has permissions of 755. Change permissions with (not working!):

```
chmod 755 /Users/admi/Sites/
```


#### The new controlling/paramount files are:

```
/private/etc/apache2/httpd.conf
```
```
/private/etc/apache2/extra/httpd-vhosts.conf
```
```
/private/etc/apache2/extra/httpd-userdir.conf
```
```
/private/etc/apache2/users/admi.conf
```
```
/private/etc/host
```

#### Common useful commands

```
sudo apachectl restart
sudo apachectl start
sudo apachectl stop
apachectl configtest
httpd -v
php -v
which apachectl
```

## Install dnscrypt

Instructions here:

```
https://github.com/dnscrypt/dnscrypt-proxy/wiki/installation
```
To be used with dnsmasq too, here: 
```
https://gist.github.com/irazasyed/88894e75034af9f8c167f0cbeede9159
```

## MAYBE Use dnsmasq instead of /etc/hosts
### Install DNSmasq
from 

```
https://www.stevenrombauts.be/2018/01/use-dnsmasq-instead-of-etc-hosts/shttps://www.stevenrombauts.be/2019/06/restart-dnsmasq-without-sudo/
```

```
brew install dnsmasq
```

To have launchd start dnsmasq now and restart at startup

```
sudo brew services start dnsmasq
```

### Configure dnsmasq
Its default configuration file is located at ```/usr/local/etc/ ```and contains examples of its most prominent features. Open that file and:

```
atom /usr/local/etc/dnsmasq.conf  
```

Add this line all the way at the bottom:

```
conf-dir=/usr/local/etc/dnsmasq.d,*.confs
```

This will instruct dnsmasq to include all files that end with .conf  in the ```/usr/local/etc/dnsmasq.d ```directory as additional configuration files. 
This way we can keep our custom configuration better organised.

### Make sure the directory exists and create our first config file:


```
mkdir -p /usr/local/etc/dnsmasq.d
```

```
atom /usr/local/etc/dnsmasq.d/development.conf
```

Add this:

```
address=/.test/127.0.0.1 
```

### Save all files and restart dnsmasq to apply the changes:

```
sudo brew services restart dnsmasq
```

### We can verify our changes using the dig command by querying our local dnsmasq instance:

```
dig foobar.test @127.0.0.1
```

We should get an answer back that points to ```127.0.0.1```:


Configure as default DNS resolver in macOS
To complete our set up we need to tell macOS to use dnsmasq for its DNS queries. We are going to send only DNS queries for ```*.test``` and ```*.box``` domains.

On most UNIX-like systems the /etc/resolv.conf file determines how DNS queries are made. 
When you make changes to the DNS Servers in macOS’s System Preferences, this file is re-generated.

For that reason we don’t want to edit it directly. 
We can however add separate resolver files inside the ```/etc/resolver/``` directory. 
Make sure it exists before continuing:

```
sudo mkdir /etc/resolver
```

The name of each configuration file will correspond to the top-level domain name, so create the file /etc/resolver/test for .test domains 

```
atom /etc/resolver/test
```

Add this line:

```
nameserver 127.0.0.1
```

This instructs the DNS resolver to send all queries for domains ending in .test to the nameserver at 127.0.0.1. 

Do the same for /etc/resolver/box:

```
ato /etc/resolver/box
``s
Add this line:

```
nameserver 127.0.0.1
```

Sometimes it can take a little while before the new configuration is applied.  We can check that our new resolvers are registered with this command: 

```
cutil --dns   
```

The output should list our top-level domains and their configured nameserver:

```
resolver #8
  domain : box
  nameserver[0] : 127.0.0.1
..
resolver #9
  domain : test
  nameserver[0] : 127.0.0.1
```


