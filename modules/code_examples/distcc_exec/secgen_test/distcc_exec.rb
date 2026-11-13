require_relative '../../../../../lib/post_provision_test'

class DistCCExecTest < PostProvisionTest
  def initialize
    self.module_name = 'distcc_exec'
    self.module_path = get_module_path(__FILE__)
    super
    self.port = 3632
  end

  def test_module
    super
    test_service_up
  end
end

DistCCExecTest.new.run