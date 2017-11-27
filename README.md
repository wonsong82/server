**THREEON CHECKOUT SERVER**

    $ git clone https://bitbucket.org/threeon/vagrant-server.git server
    $ bash init
    > edit config.json, change name example: ThreeonPlatform_01
    $ vagrant up
    $ vagrant ssh
    $ sudo su
    $ cd /scripts
    $ bash install
    > default packages: nginx1.10_php7.1_mysql5.7, git, node, composer
    > default configs: 
        - mysql root pass: root
        - db: api, plugin_wordpress
        - db_users: admin/777, threeon/1threeon 




**GENERAL:**

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