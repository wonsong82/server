class VagrantSettings
  def VagrantSettings.setConfig(config, settings)
    
	# Prevent TTY Errors
	config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
	
	# Box
	config.vm.box = settings["box"]
	
	# Private Network IP
	config.vm.network "private_network", ip: settings["ip"]
	
	# Port Forwarding
	ports = {
	  80 => 8000,
	  443 => 44300,
	  3306 => 33060,
	  5432 => 54320,
	  8080 => 18080,
	  1433 => 14330
	}
	ports.each do |guest_port, host_port|
	  config.vm.network "forwarded_port", guest: guest_port, host: host_port, auto_correct: true
	end
	
	# Shared Folders
	config.vm.synced_folder '.', '/vagrant', disabled: true
	config.vm.synced_folder './scripts', '/scripts'
	
	
	settings["folders"].each do |folder|
	  config.vm.synced_folder folder["from"], folder["to"],		
		:nfs => true
		#:mount_options => ['rw', 'nolock', 'vers=3' ,'tcp', 'noatime']
		#:mount_options => ['rw','vers=3','tcp','fsc','actimeo=2'],
		#:linux__nfs_options => ['rw','no_subtree_check','all_squash','async']
	end
	
	# Bind Folders
	settings["binds"].each do |bind|
		config.bindfs.bind_folder bind["from"], bind["to"], 
		u: bind["user"], g: bind["group"], perms: bind["permissions"]
	end
	
	
	# VirtualBox Settings
	config.vm.provider "virtualbox" do |v|
        host = RbConfig::CONFIG['host_os']
        cpus = settings["cpus"]
        mem  = settings["memory"]
        
        if cpus == "auto"
            # give vm 1/2 cpu cores
            if host =~ /darwin/
                cpus = `sysctl -n hw.ncpu`.to_i / 2
            elsif host =~ /linux/
                cpus = `nproc`.to_i / 2
            else
                cpus = `wmic cpu get NumberOfCores`.split("\n")[2].to_i / 2
            end
        end
        
        if mem == "auto"
            # give vm 1/4 system memory
            if host =~ /darwin/
                # sysctl returns bytes and we need to conver to mb
                mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
            elsif host =~ /linux/
                #meminfo shows KB and we need to convert to MB
                mem = `grep 'MemTOtal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
            else
                mem = `wmic OS get TotalVisibleMemorySize`.split("\n")[2].to_i / 1024 / 4
            end

        end
        
        v.name = settings["name"]
        v.customize ["modifyvm", :id, "--cpus", cpus]
        v.customize ["modifyvm", :id, "--memory", mem]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        v.customize ["modifyvm", :id, "--cableconnected1", "on"]
	end
			
		
  end
end
