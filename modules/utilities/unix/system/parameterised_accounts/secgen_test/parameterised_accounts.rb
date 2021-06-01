require_relative '../../../../../lib/post_provision_test'

class ParameterisedAccountsTest < PostProvisionTest
  def initialize
    self.module_name = 'parameterised_accounts'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_accounts_exist
  end

  def test_accounts_exist
    get_json_inputs['accounts'].each do |account|
      account = JSON.parse(account)
      username = account['username']
      test_local_command("#{username} account exists?", 'cat /etc/passwd', username)
    end
  end
end

ParameterisedAccountsTest.new.run