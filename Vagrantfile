# Read 'README.md' before editing this file

require 'json'
require File.expand_path('vagrant/Vagrantsettings.rb', File.dirname(__FILE__))

Vagrant.configure(2) do |config|

	if Vagrant::Util::Platform.windows?
		if !Vagrant.has_plugin? 'vagrant-winnfsd'
			print "vagrant-winnfsd is missing, please install the plugin:\n\n vagrant plugin install vagrant-winnfsd\n"
			Process.kill 9, Process.pid					
		end
	end
	
	if !Vagrant.has_plugin? 'vagrant-bindfs'
		print "vagrant-bindfs is missing, please install the plugin:\n\n vagrant plugin install vagrant-bindfs\n"
		Process.kill 9, Process.pid
	end
	
  if File.exists? 'vagrant/config.json' then
    VagrantSettings.setConfig(config, JSON.parse(File.read('vagrant/config.json')))
  else
	print 'Cannot find "vagrant/config.json".'
	Process.kill 9, Process.pid
  end  
end