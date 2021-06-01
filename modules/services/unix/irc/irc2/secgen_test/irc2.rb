require_relative '../../../../../lib/post_provision_test'

class IRC2Test < PostProvisionTest
  def initialize
    self.module_name = 'irc2'
    self.module_path = get_module_path(__FILE__)
    super
    self.port = 6667
  end

  def test_module
    super
    test_service_up
  end
end

IRC2Test.new.run