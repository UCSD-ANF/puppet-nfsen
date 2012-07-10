require 'spec_helper'

describe 'nfsen' do

  describe 'nfsen with no parameters, basic test' do
    let (:params) { { } }

    describe 'on solaris' do
      let (:facts) { {
        'operatingsystem' => 'Solaris',
        'osfamily'        => 'Solaris',
      } }

      it { should create_class('nfsen') }
      it { should create_file('nfsen init').with({
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'content' => /\/opt\/netflow\/bin/,
      }) }
      it { should create_service('nfsen').with({
        'ensure'   => 'running',
        'enable'   => true,
        'name'     => 'svc:/network/nfsen:default',
        'manifest' => '/var/svc/manifest/site/nfsen.xml',
      }) }
    end

    describe 'on CentOS' do
      let (:facts) { {
        'operatingsystem' => 'CentOS',
        'osfamily'        => 'RedHat',
      } }
      it do
        expect {
          subject
        }.to raise_error(Puppet::Error, /Unsupported OS/)
      end
    end

  end
  describe 'on a supported platform' do
    let (:facts) { {
      'operatingsystem' => 'Solaris',
      'osfamily'        => 'Solaris',
    } }
    it { should create_file('/opt/netflow').with_ensure('directory') }
    it { should create_file('/opt/netflow/etc').with_ensure('directory') }
    it { should create_file('nfsen.conf').with({
      'source' => 'puppet:///modules/nfsen/nfsen.conf',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
      'path'   => '/opt/netflow/etc/nfsen.conf',
    })}
  end
end
