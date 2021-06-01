require_relative '../../../../../lib/post_provision_test'

class SambaTest < PostProvisionTest
  def initialize
    self.module_name = 'samba'
    self.module_path = get_module_path(__FILE__)
    super
    self.port = 139
  end

  def test_module
    super
    test_service_up
  end
end

SambaTest.new.run