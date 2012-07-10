class nfsen::params {
  case $::osfamily {
    'Solaris': {
      $netflow_basedir='/opt/netflow'
      $init_script='/var/svc/manifest/site/nfsen.xml'
      $init_template='nfsen/smf/nfsen.xml.erb'
      $svc='svc:/network/nfsen:default'
      $conf_source="puppet:///modules/${module_name}/nfsen.conf"
    }
    default: {
      fail("Unsupported OS: $::operatingsystem")
    }
  }
}
