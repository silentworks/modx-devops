class grunt::install{
  
  # house keeping
  exec { 'apt_get update': 
    command => '/usr/bin/apt-get update',
  }

  package { 'ruby1.9.3':
    ensure => present,
    require => Exec['apt_get update'],
  }

  # Get node
  exec { 'add node repo':
    command => '/usr/bin/apt-add-repository ppa:chris-lea/node.js && /usr/bin/apt-get update',
    require => Package['python-software-properties'],
  }

  package { 'nodejs': 
    ensure => latest,
    require => [Exec['apt_get update'], Exec['add node repo']],
  }


  # install npm
  exec { 'npm':
    command => '/usr/bin/curl https://npmjs.org/install.sh | /bin/sh',
    require => [Package['nodejs'], Package['curl']],
    environment => 'clean=yes',
  }

  # install sass
  exec { 'gem install sass': 
    command => '/usr/bin/gem install sass',
    require => Package['ruby1.9.3'],
  }

  # create symlink to stop node-modules foler breaking
  exec { 'node-modules symlink': 
    command => '/bin/rm -rfv /usr/local/node_modules && /bin/rm -rfv /vagrant/www/_build/templates/default/node_modules && /bin/mkdir /usr/local/node_modules && /bin/ln -sf /usr/local/node_modules /vagrant/www/_build/templates/default/node_modules',
  }

  # finally install grunt
  exec { 'npm install -g grunt-cli bower':,
    command => '/usr/bin/npm install -g grunt-cli bower',
    require => Exec['npm'],
  }

  exec { 'npm-packages':,
    command => '/usr/bin/npm install',
    require => [Exec['npm install -g grunt-cli bower'], Exec['node-modules symlink']],
    cwd => '/vagrant/www/_build/templates/default',
  }
}