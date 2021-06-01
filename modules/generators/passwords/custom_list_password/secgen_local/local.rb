#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_generator.rb'

class CustomPasswordGenerator < StringGenerator
  attr_accessor :list_name

  def initialize
    super
    self.module_name = 'Custom List Password Generator'
    self.list_name = ''
  end

  def generate
    self.outputs << File.readlines("#{PASSWORDLISTS_DIR}/#{list_name}").sample.chomp
  end

  def get_options_array
    super + [['--list_name', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
      when '--list_name'
        self.list_name << arg;
    end
  end

  def encoding_print_string
    'list_name: ' + self.list_name.to_s + print_string_padding
  end

end

CustomPasswordGenerator.new.run