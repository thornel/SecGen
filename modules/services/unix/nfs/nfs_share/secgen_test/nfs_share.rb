require_relative '../../../../../lib/post_provision_test'

class NFSShareTest < PostProvisionTest
  def initialize
    self.module_name = 'ntp'
    self.module_path = get_module_path(__FILE__)
    super
    self.port = 2049
  end

  def test_module
    super
    test_service_up
  end
end

NFSShareTest.new.run