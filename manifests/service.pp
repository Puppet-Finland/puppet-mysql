#
# == Class: mysql::service
#
# Configure MySQL to start on boot
#
class mysql::service {

    include mysql::params

    service { 'mysql-mysql':
        enable => true,
        name => "${::mysql::params::service_name}",
        require => Class['mysql::install'],
    }
}
