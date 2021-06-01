require_relative '../../../../../lib/post_provision_test'

class Wordpress2xTest < PostProvisionTest
  def initialize
    self.module_name = 'wordpress_2x'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_service_up
  end
end

Wordpress2xTest.new.run