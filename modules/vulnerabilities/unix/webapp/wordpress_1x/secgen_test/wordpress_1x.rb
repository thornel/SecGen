require_relative '../../../../../lib/post_provision_test'

class Wordpress1xTest < PostProvisionTest
  def initialize
    self.module_name = 'wordpress_1x'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_service_up
  end
end

Wordpress1xTest.new.run