require_relative '../../../../../lib/post_provision_test'

class DVWATest < PostProvisionTest
  def initialize
    self.module_name = 'dvwa'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_service_up
  end
end

DVWATest.new.run