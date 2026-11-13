#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_string_generator.rb'

class XSSBlacklistGenerator < StringGenerator
  def initialize
    super
    self.module_name = 'XSS blacklist Generator'
  end

  def generate
    # 53,721,360 different possibilities
    self.outputs << File.readlines("#{WORDLISTS_DIR}/xss_blacklist", chomp: true)
                        .sample(6)
                        .join(',')
  end
end

XSSBlacklistGenerator.new.run
