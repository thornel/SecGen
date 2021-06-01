require_relative '../../../../../lib/post_provision_test'

class ChkrootkitVulnTest < PostProvisionTest
  def initialize
    self.module_name = 'chkrootkit'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('Chkrootkit binary exists?', 'sudo ls -la /usr/sbin/chkrootkit', 'chkrootkit-0.49')
    test_local_command('Chkrootkit runs?', 'sudo /usr/sbin/chkrootkit -V', 'chkrootkit version 0.49')
  end

end
ChkrootkitVulnTest.new.run