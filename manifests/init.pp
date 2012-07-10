class nfsen inherits nfsen::params {

  ### Module's internal variables
  $basedir=$nfsen::params::netflow_basedir
  $confdir="$basedir/etc"
  $conffile="$confdir/nfsen.conf"

  $manage_service_ensure = 'running'
  $manage_service_enable = true

  $manage_file_ensure = 'present'

  $manage_init_file_source = $nfsen::params::init_source

  $manage_init_file_content = $nfsen::params::init_template ? {
    ''      => undef,
    default => template($nfsen::params::init_template),
  }

  $manage_conf_file_source = $nfsen::params::conf_source

  $manage_file_owner = 'root'
  $manage_file_group = 'root'

  $manage_svc_manifest = $::osfamily ? {
    'Solaris' => $nfsen::params::init_script,
    default   => undef,
  }


  ### Managed resources
  file { 'nfsen init' :
    path    => $nfsen::params::init_script,
    ensure  => $manage_file_ensure,
    source  => $manage_init_file_source,
    content => $manage_init_file_content,
    owner   => $manage_file_owner,
    group   => $manage_file_group,
  }

  service { 'nfsen' :
    ensure   => $manage_service_ensure,
    enable   => $manage_service_enable,
    name     => $nfsen::params::svc,
    manifest => $manage_svc_manifest,
  }

  file { $basedir :
    ensure => 'directory',
    mode   => '0755',
    owner  => $manage_file_owner,
    group  => $manage_file_group,
  } ->
  file { $confdir :
    ensure => 'directory',
    mode   => '0755',
    owner  => $manage_file_owner,
    group  => $manage_file_group,
  } ->
  file { 'nfsen.conf' :
    ensure => 'file',
    source => $manage_conf_file_source,
    mode   => '0644',
    path   => $conffile,
    owner  => $manage_file_owner,
    group  => $manage_file_group,
    before => Service['nfsen'],
  }


}
