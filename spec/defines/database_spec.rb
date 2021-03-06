require 'spec_helper'

describe 'duplicity_mysql::database' do
  let(:title) { 'example' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:dump_script) { '/usr/local/sbin/dump-mysql-database.sh' }
  let(:dump_file) { '/var/backups/mysql/example.sql.gz' }
  let(:restore_script) { '/usr/local/sbin/restore-mysql-database.sh' }

  describe 'by default' do
    let(:params) { {} }

    specify { should contain_duplicity__profile_exec_before('system/mysql/example').with(
        'ensure'  => 'present',
        'profile' => 'system',
        'content' => "#{dump_script} example"
      )
    }
    specify { should contain_duplicity__file(dump_file).with(
        'ensure'  => 'present',
        'profile' => 'system'
      ) 
    }
    specify { should contain_exec("#{restore_script} example") }
  end

  describe 'with ensure => backup' do
    let(:params) { {:ensure => 'backup'} }

    specify { should contain_duplicity__profile_exec_before('system/mysql/example').with_ensure('present') }
    specify { should contain_duplicity__file(dump_file).with_ensure('backup') }
    specify { should_not contain_exec("#{restore_script} example") }
  end

  describe 'with ensure => absent' do
    let(:params) { {:ensure => 'absent'} }

    specify { should contain_duplicity__profile_exec_before('system/mysql/example').with_ensure('absent') }
    specify { should contain_duplicity__file(dump_file).with_ensure('absent') }
    specify { should_not contain_exec("#{restore_script} example") }
  end

  describe 'should not accept invalid ensure' do
    let(:params) { {:ensure => 'foobar'} }

    specify {
      expect { should contain_file(dump_file) }.to raise_error(Puppet::Error, /ensure/)
    }
  end

  describe 'with profile => backup' do
    let(:params) { {:profile => 'backup'} }

    specify {
      should contain_duplicity__profile_exec_before('backup/mysql/example').with(
        'ensure'  => 'present',
        'profile' => 'backup',
        'content' => "#{dump_script} example"
      )
    }
  end

  describe 'should not accept missing profile' do
    let(:params) { {:profile => ''} }

    specify {
      expect { should contain_file(dump_file) }.to raise_error(Puppet::Error, /profile/)
    }
  end

  describe 'with timeout => 60' do
    let(:params) { {:timeout => 60} }

    specify { should contain_duplicity__file(dump_file).with_timeout(60) }
    specify { should contain_exec("#{restore_script} example").with_timeout(60) }
  end
end
