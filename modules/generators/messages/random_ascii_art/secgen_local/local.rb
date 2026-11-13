#!/usr/bin/ruby
require 'base64'
require_relative '../../../../../lib/objects/local_string_encoder.rb'
class AsciiImageGenerator < StringEncoder
    attr_accessor :selected_art_path

  def initialize
    super
    self.module_name = 'Random Ascii Art Image Generator'
    self.selected_art_path = Dir["#{ASCII_ART_DIR}/computers/*"].sample
  end

  def encode_all
    self.outputs << File.read(self.selected_art_path)
  end

  def encoding_print_string
    'Random ascii image generator: ' + self.selected_art_path
  end
end

AsciiImageGenerator.new.run
