require_relative '../../../../../lib/post_provision_test'

class DirtyCOWTest < PostProvisionTest
  def initialize
    self.module_name = 'dirtycow'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_local_command('apt-get upgrade not performed?', 'sudo apt-get -u upgrade --assume-no','linux-image-3.')
  end

end

DirtyCOWTest.new.run