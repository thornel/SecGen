#!/usr/bin/ruby
class Vulnerabilities_Helper

  def get_vulnerabilities(flag_position)
    #Creates an array of all the available vulnerabilities
    #flag_position constant is placed in the insecure code to be replaced later with the flag option or nothing later for ctf_style
    Array[
        Vulnerability.new('password_get', '10', 'char input[1000];gets(input);', 'char input[15];scanf("%s", input);' + flag_position, 'printf("Cat Flag");'),
        Vulnerability.new('secret_function', '10', '', 'void secretFunction(){printf("This is a secret funtion!\n");' + flag_position + '}', 'printf("Dog Flag");')
    ]
  end

  def get_available_vulnerabilities(vulnerabilities, max_score, current_total)
    #Gets all the vulnerabilities based on their points value - if there's enough points left for them to be added
    vulnerabilities.select { | v | v.points.to_i <= (max_score - current_total) }
  end

  def randomly_select_vulnerability(available_vulnerabilities, flag_position, ctf_style)
    #Picks a random number that'll be used to pick out a vulnerability from the array
    i = Random.rand(0...available_vulnerabilities.length)

    #Replaces the flag position in the insecure code with either the ctf_flag or nothing
    #And returns the randomly selected vulnerability
    if ctf_style == 'true'
      available_vulnerabilities[i].insecure_code.sub flag_position, available_vulnerabilities[i].ctf_flag
    else
      available_vulnerabilities[i].insecure_code.sub flag_position, ''
    end

    return available_vulnerabilities[i]
  end

end