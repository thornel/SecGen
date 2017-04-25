#!/usr/bin/ruby
require_relative '../../../../lib/objects/local_string_generator.rb'
require_relative '../../../../lib/helpers/print.rb'
require_relative './vulnerability'
require_relative './vulnerabilities_helper'
require 'json'

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

		#Gets an array of all the available vulnerabilities
		helper = Vulnerabilities_Helper.new
		vulnerabilities = helper.get_vulnerabilities(flag_position)

		#Initialises array that will be used for the output - it will contain all the code points and the code that has been selected for that point (secure or insecure)
		code = {}
		Print.local_verbose 'Vulnerabilities added:'

		#Loops while there are still enough points left to populate and there are still vulnerabilities left to use
		while current_total < self.max_score && vulnerabilities.length > 0

			#Gets all the vulnerabilities available to choose from
			available_vulnerabilities = helper.get_available_vulnerabilities(vulnerabilities, self.max_score, current_total)

			if available_vulnerabilities.length > 0
				#Get randomly selected vulnerability
				random_vulnerability = helper.randomly_select_vulnerability(available_vulnerabilities, flag_position, ctf_style)

				#Adds vulnerability to the code array
				code[random_vulnerability.id] = random_vulnerability.insecure_code

				#Deletes the vulnerability from the array as it's already been used and added to the code array
				vulnerability_index = vulnerabilities.index{ |v| v.id ==  random_vulnerability.id }
				vulnerabilities.delete_at(vulnerability_index)

				#Adds the points for that vulnerability to the current total
				current_total = current_total + random_vulnerability.points.to_i

				#Prints out the vulnerability id to console
				Print.local_verbose '---' + random_vulnerability.id
			else
				break;
			end
		end

		#Loops through the rest of the vulnerabilities and selects their secure code to be added to the code array
		vulnerabilities.each do |v|
			code[v.id] = v.secure_code
		end

		Print.local_verbose current_total.to_s + ' total points available.'

		#Outputs the code array as a json string
		self.outputs << code.to_json
	end

end

VulnerabilitiesGenerator.new.run