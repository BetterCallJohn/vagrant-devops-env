# Vagrant Devops PHP Environment

Devops environment with Vagrant & Puppet for PHP Projects (Symfony2, Magento, Drupal, Wordpress, ...)

## Requirements
- Vagrant
- VirtualBox

## How to use it

### Step 1: init environment

````
cd /path/to/myproject 
git submodule add https://github.com/John-iw2/vagrant-devops-env.git vagrant
git submodule update --init --recursive
````

### Step 2: configure env for your project
````
cp vagrant/vagrantconfig.yaml ./
````
You can customise the file vagrantconfig.yaml and add this file in your git for your team.

````
box: 'Debian_7.3_32'
box_url: 'http://puppet-vagrant-boxes.puppetlabs.com/debian-73-i386-virtualbox-puppet.box'
box_ip: '192.168.20.20'
project_name: 'projectname'
project_path: '/var/www/projectname'
project_webroot: '/var/www/projectname/web'
project_url: 'www.projectname.local'
project_template: 'symfony' #symfony|wordpress|drupal|prestashop|magento
````
If you need specific config that you don't want under git you can add a file named 'vagrantconfig_local.yaml' and add it on your .gitignore.

### Step 3: start you env

````
cd vagrant
vagrant up
vagrant provision
vagrant ssh
````
## known issues


>Failed to mount folders in Linux guest. This is usually because  
the "vboxsf" file system is not available. Please verify that
the guest additions are properly installed in the guest and
can work properly.

Solution:

````
vagrant ssh
sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions/ /usr/lib/VBoxGuestAdditions
sudo /etc/init.d/vboxadd setup
exit
vagrant reload
vagrant provision
````
===

>Using Symfony2 inside a Vagrant box is considered to be very slow, even when using NFS

Solution: [Speedup symfony2 on vagrant boxes](http://www.whitewashing.de/2013/08/19/speedup_symfony2_on_vagrant_boxes.html)

## Installed components
* nginx
* mysql
* phpmyadmin
* php5
* composer
* nodejs & npm
* grunt
* bower

## Work in progress
* elastic search
* rabbitMQ
* mongo
* redis
* capifony
* nodejs