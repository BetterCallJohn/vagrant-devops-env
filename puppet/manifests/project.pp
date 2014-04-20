Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

class system-update {

    exec { 'apt-get update':
        command => 'apt-get update',
    }
}

class dev-packages {

	include stdlib

	$devPackages = [ "vim", "git"]
    package { $devPackages:
        ensure => "installed",
        require => Exec['apt-get update'],
    }
}

class nginx-setup {
    
    include nginx

    file { "/var/www/index.html":
	    ensure => "file",
	    content => 
	        "<html>
			<head>
			<title>Welcome to Nginx</title>
			</head>
			<body bgcolor='white' text='black'>
			<center><h1>Welcome to your new devops server</h1></center>
			</body>
			</html>",
	}

}

class php-setup {

	package {
		"memcached":
			ensure => present;							
		"php5-fpm":
			ensure => present;		
		"php5-mysql":
			ensure => present;
		"php5-curl":
			ensure => present;			
		"php5-mcrypt":
			ensure => present;
		"php5-gd":
			ensure => present;
		"php5-memcached":
			ensure => present;
		"imagemagick":
			ensure => present;		
		"php5-imagick":
			ensure => present;					
		"php-pear":
			ensure => present;
		"php5-intl":
			ensure => present;
	}	

	class { 'composer':
        target_dir      => '/usr/local/bin',
        composer_file   => 'composer', # could also be 'composer.phar'
        download_method => 'curl',     # or 'wget'
        logoutput       => false,
        tmp_path        => '/tmp',
        php_package     => 'php5-cli',
        curl_package    => 'curl',
        wget_package    => 'wget',
        composer_home   => '/root',
    }

}

class mysql-setup {
	
	class { '::mysql::server':
  		root_password    => 'strongpassword',
  		override_options => { 'mysqld' => { 'max_connections' => '1024' } }
	}

	package {
		"phpmyadmin":
        	ensure => present;
    }

    file { "/etc/nginx/sites-available/admin":
	    ensure => "file",
	    content => 
	        "
server {

	listen 80 default_server;
    server_name _;
    
    location / { root /var/www; }

	location /phpmyadmin {
        root /usr/share/;
        index index.php index.html index.htm;
        location ~ ^/phpmyadmin/(.+\\.php)$ {
          try_files \$uri =404;
          root /usr/share/;
          fastcgi_pass unix://var/run/php5-fpm.sock;
          fastcgi_index index.php;
          fastcgi_param SCRIPT_FILENAME \$request_filename;
          include /etc/nginx/fastcgi_params;
        }
        location ~* ^/phpmyadmin/(.+\\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
          root /usr/share/;
        }
    }
    location /phpMyAdmin {
    rewrite ^/* /phpmyadmin last;
    }
}",
	    notify => Service["nginx"]
	}
	file { "/etc/nginx/sites-enabled/admin":
	    require => File["/etc/nginx/sites-available/admin"],
	    ensure => "link",
	    target => "/etc/nginx/sites-available/admin",
	    notify => Service["nginx"]
	}
}


class project-setup {
	$full_web_path = $project_path

	file { "/etc/nginx/sites-available/$project_url":
        ensure => file,
        content => template("/vagrant/puppet/template/nginx/$project_template"),
    }

    file { "/etc/nginx/sites-enabled/$project_url":
        notify => Service["nginx"],
        ensure => link,
        target => "/etc/nginx/sites-available/$project_url",
        require => Package["nginx"],
    }
}

class { 'apt':
    always_apt_update    => true
}


class nodejs-setup {
	
	apt::source { 'puppetlabs':
	  	location   => 'http://ftp.us.debian.org/debian',
	  	release         => "wheezy-backports",
	  	repos      => 'main',
	}

	package { 'nodejs-legacy':
        ensure => "installed",
        require => Exec['apt-get update'],
    }

    exec { 'install npm':
        command => 'curl --insecure https://www.npmjs.org/install.sh | sudo clean=no sh',
        logoutput => "on_failure",
    }

    exec { 'install grunt + bower':,
    	command => '/usr/bin/npm install -g grunt-cli bower',
    	require => Exec['install npm'],
	}

}

Exec["apt-get update"] -> Package <| |>

include system-update
include dev-packages
include nginx-setup
include php-setup
include mysql-setup
include project-setup
#include phpqatools
include nodejs-setup