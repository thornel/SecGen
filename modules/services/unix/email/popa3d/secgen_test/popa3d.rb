require_relative '../../../../../lib/post_provision_test'

class Popa3dTest < PostProvisionTest
  def initialize
    self.module_name = 'popa3d'
    self.module_path = get_module_path(__FILE__)
    super
    self.port = 110
  end

  def test_module
    super
    test_service_up
  end
end

Popa3dTest.new.run