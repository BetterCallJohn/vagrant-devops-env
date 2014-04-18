# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

_config = YAML.load(File.open(File.join(File.dirname(__FILE__), "./vagrantconfig.yaml"), File::RDONLY).read)

begin
    _config.merge!(YAML.load(File.open(File.join(File.dirname(__FILE__), "../vagrantconfig.yaml"), File::RDONLY).read))
rescue Errno::ENOENT

end

begin
    _config.merge!(YAML.load(File.open(File.join(File.dirname(__FILE__), "../vagrantconfig_local.yaml"), File::RDONLY).read))
rescue Errno::ENOENT

end

CONF = _config


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = CONF['box']
  config.vm.box_url = CONF['box_url']

  config.vm.synced_folder "../", CONF['project_path']

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.network "private_network", ip: CONF['box_ip']

  #config.ssh.pty = true

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "project.pp"
    puppet.facter = {
      "project_path" => CONF['project_path'],
      "project_url" => CONF['project_url'],
      "project_webroot" => CONF['project_webroot'],
      "project_template" => CONF['project_template']
    }
  end
  
end