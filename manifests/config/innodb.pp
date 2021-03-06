#
# == Class: mysql::config::innodb
#
# Configure the InnoDB storage engine. This class has to be included manually 
# because adding it to the main class would result in API explosion.
#
# == Parameters
#
# [*buffer_pool_size*]
#   The amount of RAM in bytes to reserve for the InnoDB buffer pool. This will
#   improve performance when lookups tends to query the same data. Must be an
#   integer within the acceptable range, or undef. Defaults to 33554432. For
#   details on the option look here:
#
#   <https://dev.mysql.com/doc/refman/5.5/en/innodb-parameters.html>
#
# [*file_per_table*]
#   Store each table in a different InnoDB file, which is in general a good
#   idea. Valid values are true and false. Defaults to undef.
#
class mysql::config::innodb
(
    Optional[Integer] $buffer_pool_size = 33554432,
    Optional[Variant[Boolean, Enum['ON','OFF']]] $file_per_table = true

) inherits mysql::params
{

    $file_per_table_line = $file_per_table ? {
        true  => 'innodb_file_per_table = 1',
        'ON'  => 'innodb_file_per_table = 1',
        false => 'innodb_file_per_table = 0',
        'OFF' => 'innodb_file_per_table = 0',
        undef => undef,
    }

    $buffer_pool_size_line = $buffer_pool_size ? {
        undef   => undef,
        default => "innodb_buffer_pool_size = ${buffer_pool_size}"
    }

    file { 'mysql-innodb.cnf':
        ensure  => present,
        name    => "${::mysql::params::fragment_dir}/innodb.cnf",
        content => template('mysql/innodb.cnf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['mysql::config::fragmentdir'],
    }
}
