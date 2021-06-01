require_relative '../../../../../lib/post_provision_test'


class WritableShadowTest < PostProvisionTest
  def initialize
    self.module_name = 'writable_shadow'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('writable /etc/shadow?','sudo ls -la /etc/shadow', 'rwxrwxrwx')
  end

end

WritableShadowTest.new.run