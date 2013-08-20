$mysql_host = 'localhost'
$mysql_db   = 'default'
$mysql_user = 'vagrant'
$mysql_pass = 'vagrant'

class { "devops":
    mysql_host => $mysql_host,
    mysql_db => $mysql_db,
    mysql_user => $mysql_user,
    mysql_pass => $mysql_pass,
}

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

exec { 'modx_git':
    cwd    => '/vagrant',
    command => 'git clone https://github.com/rthrash/revolution.git www',
    onlyif  => 'test ! -d /vagrant/www',
    require => Package['git']
}

file { '/vagrant/www/_build/build.distrib.config.php':
    content => template('devops/modx/build.distrib.config.sample.php.erb'),
    ensure  => present,
    require => Exec['modx_git'],
}

file { '/vagrant/www/_build/build.config.php':
    content => template('devops/modx/build.config.sample.php.erb'),
    ensure  => present,
    require => Exec['modx_git'],
}

file { '/vagrant/www/_build/build.properties.php':
    content => template('devops/modx/build.properties.sample.php.erb'),
    ensure  => present,
    require => Exec['modx_git'],
}

exec { 'build_transport':
    cwd    => '/vagrant/www/_build',
    path   => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    command => 'php /vagrant/www/_build/transport.core.php',
    onlyif  => 'test -d /vagrant/www/_build',
    require => [ Class['devops'], Class['php'], Exec['modx_git'], 
                File['/vagrant/www/_build/build.distrib.config.php'], 
                File['/vagrant/www/_build/build.config.php'],
                File['/vagrant/www/_build/build.properties.php'] ],
}

file {["${docroot}core/cache", "${docroot}core/export", "${docroot}core/packages"]:
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0777',
    recurse => true,
    require => Exec['modx_git'],
    notify  => Service['apache'],
}