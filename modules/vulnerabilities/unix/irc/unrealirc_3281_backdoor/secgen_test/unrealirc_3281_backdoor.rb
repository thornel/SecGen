require_relative '../../../../../lib/post_provision_test'

class Unrealirc3281BackdoorTest < PostProvisionTest
  def initialize
    self.module_name = 'unrealirc_3281_backdoor'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_service_up
  end
end

Unrealirc3281BackdoorTest.new.run