require_relative '../../../../../lib/post_provision_test'

class Vsftpd234BackdoorTest < PostProvisionTest
  def initialize
    self.module_name = 'vsftpd_234_backdoor'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_service_up
  end
end

Vsftpd234BackdoorTest.new.run