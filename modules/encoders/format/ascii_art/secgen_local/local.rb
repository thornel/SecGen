#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_encoder.rb'
require 'artii'

class ASCIIArtEncoder < StringEncoder
  attr_accessor :font

  def initialize
    super
    self.module_name = 'Ascii Art Encoder'
    self.font = []
  end

  def encode(str)
    # if more than one font is specified, randomly choose one for every string that is encoded
    artii = Artii::Base.new :font => self.font.sample
    artii.asciify(str)
  end

  def process_options(opt, arg)
    super
    case opt
      # Removes any non-alphabet characters
    when '--font'
      self.font << arg
    else
      # do nothing
    end
  end

  def get_options_array
    super + [['--font', GetoptLong::OPTIONAL_ARGUMENT]]
  end

end

ASCIIArtEncoder.new.run
