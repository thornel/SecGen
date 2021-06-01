require_relative '../../../../../lib/post_provision_test'


class WritableGroupsTest < PostProvisionTest
  def initialize
    self.module_name = 'writable_groups'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('writable groups?','sudo ls -la /etc/group', 'rwxrwxrwx')
  end

end

WritableGroupsTest.new.run