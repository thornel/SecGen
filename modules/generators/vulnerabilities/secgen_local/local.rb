#!/usr/bin/ruby
require_relative '../../../../lib/objects/local_string_generator.rb'
require_relative '../../../../lib/helpers/print.rb'
require 'json'

class Vulnerability
	attr_accessor :vuln_id, :vuln_points, :vuln_secure, :vuln_insecure, :ctf_flag

	def initialize(id, points, secure, insecure, flag)
		@vuln_id=id
		@vuln_points=points
		@vuln_secure=secure
		@vuln_insecure=insecure
		@ctf_flag=flag
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

  #Initialises the options that are passed in from the .xml using the StringGenerator
  def get_options_array
    super + [['--max_score', GetoptLong::REQUIRED_ARGUMENT],
             ['--ctf_style', GetoptLong::REQUIRED_ARGUMENT]]
  end
  
  #Populates the variables passed in from the .xml using the StringGenerator 
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
	flag_position = '$$ctf_flag'

	#Creates an array of all the available vulnerabilities
	#flag_position constant is placed in the insecure code to be replaced later with the flag option or nothing later for ctf_style
	vulnerabilities = Array[
		Vulnerability.new('password_get', '10', 'char input[1000];gets(input);', 'char input[15];scanf("%s", input);' + flag_position, 'printf("Cat Flag");'),
		Vulnerability.new('secret_function', '10', '', 'void secretFunction(){printf("This is a secret funtion!\n");' + flag_position + '}', 'printf("Dog Flag");')
	]
	
	#Initialises array that will be used for the output - it will contain all the code points and the code that has been selected for that point (secure or insecure)
	code = {}
	Print.local_verbose "Vulnerabilities added:"
	
	#Loops while there are still enough points left to populate and there are still vulnerabilities left to use
	while current_total < self.max_score && vulnerabilities.length > 0
		#Gets all the vulnerabilities based on their points value - if there's enough points left for them to be added
		available_vulns = vulnerabilities.select { | vuln | vuln.vuln_points.to_i <= (self.max_score - current_total) }

		if available_vulns.length > 0
			#Picks a random number that'll be used to pick out a vulnerability from the array
			i = Random.rand(0...available_vulns.length)		

			#Replaces the flag position in the insecure code with either the ctf_flag or nothing
			if self.ctf_style == "true"
				code[available_vulns[i].vuln_id] = available_vulns[i].vuln_insecure.sub flag_position, vulnerabilities[i].ctf_flag
			else
				code[available_vulns[i].vuln_id] = available_vulns[i].vuln_insecure.sub flag_position, ''
			end
			Print.local_verbose "---" + available_vulns[i].vuln_id		
			
			#Deletes the vulnerability from the array as it's already been used and added to the code array
			vuln_index = vulnerabilities.index{ |vuln| vuln.vuln_id ==  available_vulns[i].vuln_id }
			vulnerabilities.delete_at(vuln_index)
			
			#Adds the points for that vulnerability to the current total
			current_total = current_total + available_vulns[i].vuln_points.to_i
		else
			break;
		end
  	end
	
	#Loops through the rest of the vulnerabilities and selects their secure code to be added to the code array
	vulnerabilities.each do |i|
		code[vulnerabilities[i].vuln_id] = vulnerabilities[i].vuln_secure
	end
		
	
	Print.local_verbose current_total.to_s + " total points available."	

	#Outputs the code array as a json string
	self.outputs << code.to_json
  end

end

VulnerabilitiesGenerator.new.run
