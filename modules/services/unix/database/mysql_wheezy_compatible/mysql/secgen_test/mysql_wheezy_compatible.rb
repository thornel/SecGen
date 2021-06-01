require_relative '../../../../../lib/post_provision_test'

class MySQLWheezyTest < PostProvisionTest
  def initialize
    self.module_name = 'mysql_wheezy_compatible'
    self.module_path = get_module_path(__FILE__)
    super
    self.port = 3306
  end

  def test_module
    super
    test_local_command('mysqld process running?', 'ps -ef | grep mysqld', '/usr/bin/mysqld')
  end
end

MySQLWheezyTest.new.run