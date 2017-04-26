require 'test/unit'
require 'mocha/test_unit'
require './modules/generators/vulnerabilities/secgen_local/vulnerabilities_helper'

class VulnerabilitiesHelperTest < Test::Unit::TestCase

  def test_randomly_select_vulnerability_should_return_vulnerability_without_flag
    #ARRANGE
    flag_position = '$$ctf_flag'
    ctf_style = 'false'

    vulnerability = Vulnerability.new('v1', '10', 'char input[1000];gets(input);', 'char input[15];scanf("%s", input);' + flag_position, 'printf("v1 Flag");')
    available_vulnerabilities = Array[
      vulnerability
    ]

    helper = VulnerabilitiesHelper.new

    #ACT
    result = helper.randomly_select_vulnerability(available_vulnerabilities, flag_position, ctf_style)

    #ASSERT
    assert_equal(vulnerability.id, result.id)
    assert_equal(vulnerability.points, result.points)
    assert_equal(vulnerability.secure_code, result.secure_code)
    assert_equal('char input[15];scanf("%s", input);', result.insecure_code)
    assert_equal(vulnerability.ctf_flag, result.ctf_flag)
  end

  def test_randomly_select_vulnerability_should_return_vulnerability_with_flag
    #ARRANGE
    flag_position = '$$ctf_flag'
    ctf_style = 'true'

    vulnerability = Vulnerability.new('v1', '10', 'char input[1000];gets(input);', 'char input[15];scanf("%s", input);' + flag_position, 'printf("v1 Flag");')
    available_vulnerabilities = Array[
        vulnerability
    ]

    helper = VulnerabilitiesHelper.new

    #ACT
    result = helper.randomly_select_vulnerability(available_vulnerabilities, flag_position, ctf_style)

    #ASSERT
    assert_equal(vulnerability.id, result.id)
    assert_equal(vulnerability.points, result.points)
    assert_equal(vulnerability.secure_code, result.secure_code)
    assert_equal('char input[15];scanf("%s", input);printf("v1 Flag");', result.insecure_code)
    assert_equal(vulnerability.ctf_flag, result.ctf_flag)
  end

  def test_get_available_vulnerabilities_should_return_all_vulnerabilities
    #ARRANGE
    max_score = 40
    current_total = 0

    v1 = Vulnerability.new('v1', '10', 'secure code 1', 'insecure code 1', 'printf("v1 Flag");')
    v2 = Vulnerability.new('v2', '10', 'secure code 2', 'insecure code 2', 'printf("v2 Flag");')
    v3 = Vulnerability.new('v3', '20', 'secure code 3', 'insecure code 3', 'printf("v3 Flag");')

    available_vulnerabilities = Array[v1, v2, v3]

    helper = VulnerabilitiesHelper.new

    #ACT
    result = helper.get_available_vulnerabilities(available_vulnerabilities, max_score, current_total)

    #ASSERT
    assert_equal(available_vulnerabilities, result)
  end

  def test_get_available_vulnerabilities_should_return_some_vulnerabilities
    #ARRANGE
    max_score = 40
    current_total = 30

    v1 = Vulnerability.new('v1', '10', 'secure code 1', 'insecure code 1', 'printf("v1 Flag");')
    v2 = Vulnerability.new('v2', '10', 'secure code 2', 'insecure code 2', 'printf("v2 Flag");')
    v3 = Vulnerability.new('v3', '20', 'secure code 3', 'insecure code 3', 'printf("v3 Flag");')

    available_vulnerabilities = Array[v1, v2, v3]

    helper = VulnerabilitiesHelper.new

    #ACT
    result = helper.get_available_vulnerabilities(available_vulnerabilities, max_score, current_total)

    #ASSERT
    assert_equal([v1, v2], result)
  end

  def test_get_available_vulnerabilities_should_return_no_vulnerabilities_for_no_points_left
    #ARRANGE
    max_score = 30
    current_total = 30

    v1 = Vulnerability.new('v1', '10', 'secure code 1', 'insecure code 1', 'printf("v1 Flag");')
    v2 = Vulnerability.new('v2', '10', 'secure code 2', 'insecure code 2', 'printf("v2 Flag");')
    v3 = Vulnerability.new('v3', '20', 'secure code 3', 'insecure code 3', 'printf("v3 Flag");')

    available_vulnerabilities = Array[v1, v2, v3]

    helper = VulnerabilitiesHelper.new

    #ACT
    result = helper.get_available_vulnerabilities(available_vulnerabilities, max_score, current_total)

    #ASSERT
    assert_equal([], result)
  end

  def test_get_available_vulnerabilities_should_return_no_vulnerabilities_for_some_points_left
    #ARRANGE
    max_score = 30
    current_total = 25

    v1 = Vulnerability.new('v1', '10', 'secure code 1', 'insecure code 1', 'printf("v1 Flag");')
    v2 = Vulnerability.new('v2', '10', 'secure code 2', 'insecure code 2', 'printf("v2 Flag");')
    v3 = Vulnerability.new('v3', '20', 'secure code 3', 'insecure code 3', 'printf("v3 Flag");')

    available_vulnerabilities = Array[v1, v2, v3]

    helper = VulnerabilitiesHelper.new

    #ACT
    result = helper.get_available_vulnerabilities(available_vulnerabilities, max_score, current_total)

    #ASSERT
    assert_equal([], result)
  end

end