#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_generator.rb'
class HexGenerator < StringGenerator
  def initialize
    super
    self.module_name = 'Random Hex Generator'
  end

  def generate
    require 'securerandom'
    flag = SecureRandom.hex.slice(1..8)
    self.outputs << "flag{#{flag}}"
  end
end

HexGenerator.new.run
