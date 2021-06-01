require_relative '../../../../../lib/post_provision_test'

class Wordpress3xTest < PostProvisionTest
  def initialize
    self.module_name = 'wordpress_3x'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_service_up
  end
end

Wordpress3xTest.new.run