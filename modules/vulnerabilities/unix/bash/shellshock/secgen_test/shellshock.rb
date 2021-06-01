require_relative '../../../../../lib/post_provision_test'


class ShellshockTest < PostProvisionTest
  def initialize
    self.module_name = 'shellshock'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('correct /bin/bash version?','/bin/bash --version', 'version 4.1')
  end

end

ShellshockTest.new.run