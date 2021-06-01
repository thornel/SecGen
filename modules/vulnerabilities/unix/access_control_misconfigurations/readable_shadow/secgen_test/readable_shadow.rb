require_relative '../../../../../lib/post_provision_test'


class ReadableShadowTest < PostProvisionTest
  def initialize
    self.module_name = 'readable_shadow'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('Shadow readable?','sudo ls -la /etc/shadow', '-rw-r--r--')
  end

end

ReadableShadowTest.new.run