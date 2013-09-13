class devops(
  $doc_root        = '/vagrant/www',
  $php_modules     = ['imagick', 'xdebug', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache'],
  $sys_packages    = ['build-essential', 'git', 'curl', 'vim'],
  $mysql_host      = 'localhost',
  $mysql_db        = 'default',
  $mysql_user      = 'vagrant',
  $mysql_pass      = 'vagrant',
  $pma_port        = 8000
) {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  exec { 'apt-get update':
    command => 'apt-get update',
  }

  class { 'apt':
    always_apt_update => true,
  }

  package { ['python-software-properties']:
    ensure  => present,
    require => Exec['apt-get update'],
  }

  package { $sys_packages:
    ensure => "installed",
    require => Exec['apt-get update'],
  }
  class { "apache": }

  apache::module { 'rewrite': }

  apache::vhost { 'default':
    docroot             => $doc_root,
    server_name         => false,
    priority            => '',
    template            => 'apache/virtualhost/vhost.conf.erb',
  }

  apt::ppa { 'ppa:ondrej/php5-oldstable':
    before  => Class['php'],
  }

  class { 'php': }

  php::module { $php_modules: }

  php::ini { 'php':
    value   => ['date.timezone = "Europe/London"','upload_max_filesize = 8M', 'short_open_tag = 0'],
    target  => 'php.ini',
    service => 'apache',
  }

  class { 'mysql':
    root_password => 'root',
    require       => Exec['apt-get update'],
  }

  mysql::grant { 'default_db':
    mysql_privileges     => 'ALL',
    mysql_db             => $mysql_db,
    mysql_user           => $mysql_user,
    mysql_password       => $mysql_pass,
    mysql_host           => $mysql_host,
    mysql_grant_filepath => '/home/vagrant/puppet-mysql',
  }

  package { 'phpmyadmin':
    require => Class[ 'mysql' ],
  }

  apache::vhost { 'phpmyadmin':
    server_name => false,
    docroot     => '/usr/share/phpmyadmin',
    port        => $pma_port,
    priority    => '10',
    require     => Package['phpmyadmin'],
    template    => 'devops/apache/vhost.conf.erb',
  }

  file { '/etc/php5/mods-available/xdebug.ini':
    content => template('devops/php/xdebug.ini'),
    ensure  => file,
    require => Class['php'],
    notify  => Service['apache2'],
  }

  # Change Apache user to vagrant
  file{ '/tmp/apacheuser.sh':
      source => 'puppet:///modules/devops/apacheuser.sh'
  }

  exec{ 'change apache user':
      command => 'bash /tmp/apacheuser.sh',
      require => Class['php'],
      notify  => Service['apache2'],
  }

  class { 'devops::composer': }
}
