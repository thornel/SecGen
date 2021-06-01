require_relative '../../../../../lib/post_provision_test'


class SUIDNanoTest < PostProvisionTest
  def initialize
    self.module_name = 'suid_root_nano'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('nano suid bit set?','sudo ls -la /bin/nano', '-rwsrwxrwx')
    test_local_command('nano runs?','/bin/nano --version', 'GNU nano')
  end

end

SUIDNanoTest.new.run