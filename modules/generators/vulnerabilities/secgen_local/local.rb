#!/usr/bin/ruby
require_relative '../../../../lib/objects/local_string_generator.rb'
require_relative '../../../../lib/helpers/print.rb'
require 'json'

class Vulnerability
	attr_accessor :vuln_id, :vuln_code_id, :vuln_points, :vuln_secure, :vuln_insecure, :vuln_with_flag

	def initialize(id, code_id, points, secure, insecure, flag)
		@vuln_id=id
		@vuln_code_id=code_id
		@vuln_points=points
		@vuln_secure=secure
		@vuln_insecure=insecure
		@vuln_with_flag=flag
	end
end

class VulnerabilitiesGenerator < StringGenerator
  attr_accessor :max_score
  attr_accessor :ctf_style

  def initialize
    super
    self.module_name = 'Vulnerabilities Generator / Builder'
	self.max_score = ''
	self.ctf_style = ''
  end

  def get_options_array
    super + [['--max_score', GetoptLong::REQUIRED_ARGUMENT],
             ['--ctf_style', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
      when '--max_score'
        self.max_score << arg;
      when '--ctf_style'
        self.ctf_style << arg;
    end
  end

  def generate
	self.max_score = self.max_score.to_i
	current_total = 0

	vulnerabilities = Array[
		Vulnerability.new('1', 'password_get', '10', 'char input[1000];gets(input);', 'char input[15];scanf("%s", input);', 'char input[15];scanf("%s", input);printf("Cat Flag");'),
		Vulnerability.new('2', 'secret_function', '10', '', 'void secretFunction(){printf("This is a secret funtion!\n");}', 'void secretFunction(){printf("This is a secret funtion!\n");printf("Dog Flag");}')
	]
	
	code = {}
	Print.local_verbose "Vulnerabilities added:"
	
	while current_total < self.max_score && vulnerabilities.length > 0
		i = Random.rand(0...vulnerabilities.length)
		
		current_vuln_points = vulnerabilities[i].vuln_points.to_i

		if current_vuln_points <= (self.max_score - current_total)
			if self.ctf_style == "false"
				code[vulnerabilities[i].vuln_code_id] = vulnerabilities[i].vuln_insecure
			else
				code[vulnerabilities[i].vuln_code_id] = vulnerabilities[i].vuln_with_flag
			end
			Print.local_verbose "---" + vulnerabilities[i].vuln_code_id

			vulnerabilities.delete_at(i)
			current_total = current_total + current_vuln_points
		else
			break;
		end
  	end
	
	Print.local_verbose current_total.to_s + " total points available."	
	self.outputs << code.to_json
  end

end

VulnerabilitiesGenerator.new.run
