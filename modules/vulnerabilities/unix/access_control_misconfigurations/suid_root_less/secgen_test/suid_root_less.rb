require_relative '../../../../../lib/post_provision_test'


class SUIDLessTest < PostProvisionTest
  def initialize
    self.module_name = 'suid_root_less'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('less suid bit set?','sudo ls -la /bin/less', '-rwsrwxrwx')
    test_local_command('less runs?','/bin/less --help', 'Commands marked with * may be preceded by a number')
  end

end

SUIDLessTest.new.run