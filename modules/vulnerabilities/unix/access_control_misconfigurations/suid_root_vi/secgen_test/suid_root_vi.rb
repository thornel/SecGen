require_relative '../../../../../lib/post_provision_test'


class SUIDviTest < PostProvisionTest
  def initialize
    self.module_name = 'suid_root_vi'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('vi suid bit set?','sudo ls -la $(readlink -f `whereis vim`)', 'rwsrwxrwx')
  end

end

SUIDviTest.new.run