require_relative '../../../../../lib/post_provision_test'
require 'net/ntp'

class NTPTest < PostProvisionTest
  def initialize
    self.module_name = 'ntp'
    self.module_path = get_module_path(__FILE__)
    super
    self.port = 123
  end

  def test_module
    super
    test_ntp_query
  end

  def test_ntp_query
    time_response = ''
    retries = 5
    while retries > 0
      begin
        time_response = Net::NTP.get(system_ip, port).time
        break
      rescue Errno::ECONNREFUSED, Timeout::Error
        # do nothing
      end
      sleep 2
      retries = -1
    end
    if time_response != ''
      self.outputs << "PASSED: NTP responded on UDP port #{port} with #{time_response}"
    else
      self.outputs << "FAILED: unable to connect to #{module_name} on UDP port #{port}"
      self.all_tests_passed = false
    end
  end
end

NTPTest.new.run