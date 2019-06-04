# Development Environment Setup Guide

### Prerequisites
-----------------------------------
**CHECK OPERATING SYSTEM BIT VERSION**

1. Click the *Start* or *Windows* button on the bottom left, enter *This PC* in the search box
2. Right-click on *Computer*, then click *Properties*. 
3. Look for *System Type* under System. It should say either 32-bit or 64-bit Operating System.

**DOWNLOAD**

1. PhpStorm
 * Download from https://www.jetbrains.com/phpstorm/
2. Git BASH
 * Download from https://gitforwindows.org
 * While installing, unselect GUI tree, use vim.
3. Sourcetree
 * Download from https://www.sourcetreeapp.com/
 * Atlassian account is required.
4. PHP
 * Download a zip file from https://windows.php.net/download 
 * Extract the zip file.
 * Move everything into a new folder in *Local Disk (C:)* and name the folder as php
5. VM VirtualBox
 * Download from https://www.virtualbox.org/wiki/Downloads
 * Click Windows hosts 
6. Vagrant
 * Download from https://www.vagrantup.com/downloads.html
7. MySQL Workbench
 * Download from https://dev.mysql.com/downloads/workbench/
 * Download *MySQL Workbench Windows Prerequisites*. It should be specified in the middle of the instruction on the website.
 * Scroll down and click *Looking for previous GA versions?*
 * Select 6.x.x Version (as of 2018) 
8. Notepad++ (Optional)
 * Download from https://notepad-plus-plus.org/download/

------------------

**THREEON CHECKOUT SERVER**

```
user@threeon:~$ mkdir works
user@threeon:works $
user@threeon:works $ git clone https://bitbucket.org/threeon/vagrant-server.git server
user@threeon:works/server $ bash init
 > If bash init does not work 
   user@works/server/vagrant:~$ cp config.json.sample config.json  
user@threeon:works/server $ vagrant up
user@threeon:works/server $ vagrant ssh
vagrant@vagrant:~$ sudo su
vagrant@vagrant:~$ cd /scripts  * Important not /server/scripts *
vagrant@vagrant:~$ bash install
 > default packages: nginx1.10_php7.1_mysql5.7, git, node, composer
 > default configs: 
    - mysql root pass: root
    - db: api, plugin_wordpress
    - db_users: admin/777, threeon/1threeon
```

**NOTES**

Downloading vagrant plugins
```
user@works/server:~$ vagrant plugin install <plugin-name>
```

Might need:

 * vagrant-winnfsd
 * vagrant-bindfs


==========================================================================


## General Project Setup

### Prerequisites
-------------------------------------------------------------------------
**ENABLE PHP EXTENSIONS**

1. Edit php.ini file in Local Drive (C:)

	```
	user@threeon:~$ vim c:/PHP/php.ini
	```

2. Search for extensions

	Press ESC key and type > /extension= 

3. Enable extensions by uncommenting ";extension=modulename"

**ENABLE HOSTS**

1. Go to Local Disk (C:) > Windows > System32 > drivers > etc
2. Righ-click on hosts file and select Send To > Desktop (create shortcut)
3. Go to Desktop and open hosts - Shortcut file with Notepad++
4. Uncomment:

	```
	127.0.0.1       localhost
	::1             localhost
	```

5. Add: 

	```
	192.168.10.10	localhost
	```

**General Project Set up**

```
user@threeon:works $ git clone https://projectURLExample.git
user@threeon:works $ cd project
user@threeon:works/project $ composer install
user@threeon:works/project $ npm install
user@threeon:works/project $ cp .env.example .env
user@threeon:works/project $ vim .env
 > Configure APP_URL and DB properties if needed
 > If APP_KEY is not defined properly or empty,
	user@works/project:~$ php artisan key:generate
```
	
**CONFIGURE PROJECT**

First, open the hosts file and add *192.168.10.10 project.local* along with other addresses.
Then,

```
user@threeon:works/server $ vagrant up
user@threeon:works/server $ vagrant ssh
vagrant@vagrant:~$ cd /scripts/config/lamp/sites/sample
vagrant@vagrant:/scripts/config/lamp/sites/sample $ cp sample.conf ../project.conf
vagrant@vagrant:/scripts/config/lamp/sites/sample $ cd ..
vagrant@vagrant:/scripts/config/lamp/sites $ vim project.conf
 > Edit Virtual Host port number (line 7)
   - 443 to 80
 > Edit Servername (line 9) 
   - domain.com to project.local
 > Edit DocumentRoot and Directory (line 11 and 19) 
   - "/var/www/namespace/name/www" to "/var/www/<projectFolderName>/public"
 > Edit line 29 if php version on vagrant does not match
 > OR comment out the <IfModule> part regarding php (lines from 27 to 31)
 > Edit ErrorLog and CustomLog (line 33 and 34)
   - Replace namespace.name to <project name>
vagrant@vagrant:/scripts/config/lamp/sites $ cd /scripts
vagrant@vagrant:/scripts $ bash setup
```


**TO START PROJECT**

```
user@works/project:~$ npm start 
```

---

**GENERAL WITH VAGRANT:**

Synchronize between servers and locals run with vagrant.

Control packages by folders.
Install programs and share the configurations with simple scripts.

To be started, first setup a server by followings:

**If you are setting up local server using vagrant & VirtualBox:**

	> Install vagrant
	> Git clone this
	> Change vagrant/config.json.sample to config.json and configure : You can do this by 'bash init'
	> Start vagrant
		# vagrant up	
	> Log into ssh
		# vagrant ssh	

**If you are setting up actual server:**

	> Log into ssh
	> Git clone this
	> Set symlink ./scripts to /scripts
    		# ln -s [src] [to]    	
	
**After you are done with the server setup:**

	> Change scripts/.packages.sample to .packages and configure
	> Run desired scripts

**Install and setup programs with simple scripts:**

	// To install all packages listed on .packages
	// * Before running scripts, make sure to check inc directory and change configs accordingly.
	> bash install

	// To install specific package(s) listed on .packages.list
	> bash install $package1 $package2 ..

	// To run the desinated setup & configuration tasks
	> bash setup // for all
	> bash setup $package1 $package2 .. // for specifics

	// To remove
	> bash remove // for all
	> bash remove $package1 $package2 .. // for specifics

**Notes:**

    // $HOME/.composer/vendor/bin is added to .bashrc

**TO UPDATE UBUNTU VERSION**

1. Change `.vagrant` folder name to `.vagrant_xenial` for backup

2. Create `server/scripts/apps/bionic` folder

3. Copy all inside `server/scripts/apps/xenial` to `server/scripts/apps/bionic`

4. Edit `server/scripts/packages` file

	```
	version='xenial' > version='bionic'
	```
	
5. Edit server/vagrant/config.json for new version

	```
	"name":"Ubuntu_16.04", > "name":"Ubuntu_18.04",
	```
	
	```
	"box":"bento/ubuntu-16.04", > "box":"bento/ubuntu-18.04",
	```

6. Execute `vagrant up`