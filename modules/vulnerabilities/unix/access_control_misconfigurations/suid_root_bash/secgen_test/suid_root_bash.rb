require_relative '../../../../../lib/post_provision_test'


class SUIDBashTest < PostProvisionTest
  def initialize
    self.module_name = 'suid_root_bash'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('bash suid bit set?','sudo ls -la /bin/bash', '-rwsrwxrwx')
    test_local_command('bash runs?','/bin/bash --version', 'GNU bash')
  end

end

SUIDBashTest.new.run