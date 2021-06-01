require_relative '../../../../../lib/post_provision_test'

class WEBGOATTest < PostProvisionTest
  def initialize
    self.module_name = 'webgoat'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_service_up
  end
end

WEBGOATTest.new.run
