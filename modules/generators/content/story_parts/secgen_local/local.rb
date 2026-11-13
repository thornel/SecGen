#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_generator.rb'

class LineGenerator < StringGenerator
  attr_accessor :story
  attr_accessor :number_of_elements

  def initialize
    super
    self.story = []
    self.number_of_elements = [5]
    self.module_name = 'Story Parts Generator'
  end

  def get_options_array
    super + [['--story', GetoptLong::OPTIONAL_ARGUMENT],
      ['--number_of_elements', GetoptLong::OPTIONAL_ARGUMENT],]
  end

  def process_options(opt, arg)
    super
    case opt
    when '--story'
        self.story << arg
    when '--number_of_elements'
        self.number_of_elements = [arg]
    end
  end

  # split the array in to N equal groups
  # https://stackoverflow.com/a/13634446
  def in_groups(array, number)
    group_size = array.size / number
    leftovers = array.size % number

    groups = []
    start = 0
    number.times do |index|
      length = group_size + (leftovers > 0 && leftovers > index ? 1 : 0)
      groups << array.slice(start, length)
      start += length
    end

    groups
  end

  def generate
    # read all the lines
    lines = File.readlines("#{STORY_DIR}/#{self.story.sample.chomp}", :encoding => 'ISO-8859-1')

    # # group the last lines all together
    # individual_lines = lines[0.. self.number_of_elements.sample.chomp.to_i - 1]
    # merged_lines = lines[self.number_of_elements.sample.chomp.to_i ..-1].join("\n")

    # self.outputs = [individual_lines, merged_lines].flatten

    grouped = in_groups(lines, self.number_of_elements.sample.chomp.to_i)
    grouped.each { |group|
      self.outputs << group.join("\n")
    }
    # puts grouped.to_s
    # puts self.outputs.to_s
    # exit(1)
  end
end

LineGenerator.new.run
