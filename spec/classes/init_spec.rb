require 'spec_helper'

describe 'duplicity_mysql' do
  let(:title) { 'duplicity_mysql' }
  let(:facts) { {:osfamily => 'Debian'} }

  describe 'by default' do
    let(:params) { {} }

    it { should contain_file('/usr/local/sbin/dump-mysql-database.sh').with(
        'ensure' => 'file',
        'mode'   => '0755',
      )
    }
    it { should contain_file('/var/backups/mysql').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0600',
      )
    }
  end
end

