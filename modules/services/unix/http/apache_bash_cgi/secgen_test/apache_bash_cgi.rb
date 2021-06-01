require_relative '../../../../../lib/post_provision_test'

class ApacheBashCGITest < PostProvisionTest
  def initialize
    self.module_name = 'apache_bash_cgi'
    self.module_path = get_module_path(__FILE__)
    super
    self.port = 80
  end

  def test_module
    super
    test_service_up
  end
end

ApacheBashCGITest.new.run