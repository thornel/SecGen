require 'test/unit'
require 'mocha/test_unit'
require './modules/generators/vulnerabilities/secgen_local/vulnerabilities_helper'

class VulnerabilitiesHelperTest < Test::Unit::TestCase

  def test_randomly_select_vulnerability_should_return_vulnerability
    #ARRANGE
    flag_position = '$$ctf_flag'
    ctf_style = 'false'

    vulnerability = Vulnerability.new('v1', '10', 'char input[1000];gets(input);', 'char input[15];scanf("%s", input);' + flag_position, 'printf("Vuln1 Flag");')
    available_vulnerabilities = Array[
      vulnerability
    ]

    helper = Vulnerabilities_Helper.new

    #ACT
    result = helper.randomly_select_vulnerability(available_vulnerabilities, flag_position, ctf_style)

    #ASSERT
    assert_equal(result.id, result.id)
    assert_equal(result.points, result.points)
    assert_equal(result.secure_code, result.secure_code)
    assert_equal(result.insecure_code, result.insecure_code)
    assert_equal(result.ctf_flag, result.ctf_flag)
  end
end