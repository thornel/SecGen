#!/usr/bin/ruby
require 'base64'
require_relative '../../../../../lib/objects/local_string_encoder.rb'
class ImageGenerator < StringEncoder
    attr_accessor :image_filename

  def initialize
    super
    self.module_name = 'Scenario Image Generator'
    self.image_filename = ''
  end

def encode_all
    filepath = "#{IMAGES_DIR}/scenario/#{image_filename}"
    file_contents = File.binread(filepath)
    self.outputs << Base64.strict_encode64(file_contents)
  end

  def get_options_array
    super + [['--image_filename', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
      when '--image_filename'
        self.image_filename << arg;
    end
  end

  def encoding_print_string
    'Scenario image generator: ' + self.image_filename
  end
end

ImageGenerator.new.run