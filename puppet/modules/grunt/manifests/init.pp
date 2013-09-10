class grunt::install{
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  package { 'ruby1.9.3':
    ensure => present,
    require => Exec['apt-get update'],
  }

  # Get node
  exec { 'add node repo':
    command => 'apt-add-repository ppa:chris-lea/node.js && /usr/bin/apt-get update',
    require => Package['python-software-properties'],
  }

  package { 'nodejs': 
    ensure => latest,
    require => [Exec['apt-get update'], Exec['add node repo']],
  }


  # install npm
  exec { 'npm':
    command => 'curl https://npmjs.org/install.sh | /bin/sh',
    require => [Package['nodejs'], Package['curl']],
    environment => 'clean=yes',
  }

  # install sass
  exec { 'gem install sass': 
    command => 'gem install sass',
    require => Package['ruby1.9.3'],
  }

  # create symlink to stop node-modules foler breaking
  exec { 'node-modules symlink': 
    command => 'rm -rfv /usr/local/node_modules && rm -rfv /vagrant/www/_build/templates/default/node_modules && mkdir /usr/local/node_modules && ln -sf /usr/local/node_modules /vagrant/www/_build/templates/default/node_modules',
  }

  # finally install grunt
  exec { 'npm install -g grunt-cli bower':,
    command => 'npm install -g grunt-cli bower',
    require => Exec['npm'],
  }

  exec { 'npm-packages':,
    command => 'npm install',
    cwd => '/vagrant/www/_build/templates/default',
    require => [Exec['npm install -g grunt-cli bower'], Exec['node-modules symlink']],
  }
}