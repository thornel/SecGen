require_relative '../../../../../lib/post_provision_test'


class WritablePasswdTest < PostProvisionTest
  def initialize
    self.module_name = 'writable_passwd'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('writable /etc/passwd?','sudo ls -la /etc/passwd', 'rwxrwxrwx')
  end

end

WritablePasswdTest.new.run