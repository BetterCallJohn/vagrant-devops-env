# -*- mode: ruby -*-
# vi: set ft=ruby :

# General project settings
project_name = "projectname"
ip_address = "192.168.10.01"
project_path = "/var/www/"+project_name


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "Debian_7.3_32"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-73-i386-virtualbox-puppet.box"

  config.vm.synced_folder "./", project_path

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.network "private_network", ip: ip_address

  config.ssh.pty = true

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "project.pp"
  end
  
end