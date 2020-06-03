#
# == Define: pf_mysql::config::useropts
#
# Set up a user-specific pf_mysql configuration file
#
# == Parameters
#
# [*owner*]
#   Name of the system user for whom pf_mysql is configured. Used in the config 
#   file path and permissions.
# [*dbuser*]
#   The default database user name.
# [*password*]
#   The default database user password.
#
define pf_mysql::config::useropts
(
    String           $owner,
    String           $dbuser,
    Optional[String] $password
)
{
    $config_file = $owner ? {
        'root'  => '/root/.my.cnf',
        default => "/home/${owner}/.my.cnf",
    }

    file { "${owner}-.my.cnf":
        ensure  => present,
        name    => $config_file,
        content => template('pf_mysql/user-my.cnf.erb'),
        owner   => $owner,
        group   => $owner,
        mode    => '0640',
    }
}
