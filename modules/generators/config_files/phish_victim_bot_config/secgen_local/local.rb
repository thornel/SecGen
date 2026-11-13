#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_encoder.rb'
require 'faker'

class PhishConfigGenerator < StringEncoder
  attr_accessor :user
  attr_accessor :pass
  attr_accessor :server
  attr_accessor :recipients_name
  attr_accessor :trusted_sender
  attr_accessor :senders_name
  attr_accessor :relevant_keyword
  attr_accessor :num_keywords
  attr_accessor :accepted_file_extension
  attr_accessor :suspicious_of_file_name
  attr_accessor :reject_all

  def initialize
    super
    self.module_name = 'Phish Victim Bot Config'
    self.user = 'admin'
    self.pass = 'admin'
    self.server = 'localhost'
    self.recipients_name = ''
    self.trusted_sender = ''
    self.senders_name = ''
    self.relevant_keyword = ''
    self.num_keywords = '0'
    self.accepted_file_extension = ''
    self.suspicious_of_file_name = 'false'
    self.reject_all = 'false'
  end

  def encode_all
    # ensure variables are populated
output = <<-FOO
user=#{self.user}
pass=#{self.pass}
server=#{self.server}
recipients_name=#{self.recipients_name}
trusted_sender=#{self.trusted_sender}
senders_name=#{self.senders_name}
relevant_keyword=#{self.relevant_keyword}
num_keywords=#{self.num_keywords}
accepted_file_extension=#{self.accepted_file_extension}
suspicious_of_file_name=#{self.suspicious_of_file_name}
reject_all=#{self.reject_all}
FOO
    self.outputs << output
  end

  def get_options_array
    super + [['--user', GetoptLong::OPTIONAL_ARGUMENT],
             ['--pass', GetoptLong::OPTIONAL_ARGUMENT],
             ['--server', GetoptLong::OPTIONAL_ARGUMENT],
             ['--trusted_sender', GetoptLong::OPTIONAL_ARGUMENT],
             ['--senders_name', GetoptLong::OPTIONAL_ARGUMENT],
             ['--relevant_keyword', GetoptLong::OPTIONAL_ARGUMENT],
             ['--num_keywords', GetoptLong::OPTIONAL_ARGUMENT],
             ['--accepted_file_extension', GetoptLong::OPTIONAL_ARGUMENT],
             ['--suspicious_of_file_name', GetoptLong::OPTIONAL_ARGUMENT],
             ['--reject_all', GetoptLong::OPTIONAL_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
      when '--user'
        self.user = arg;
      when '--pass'
        self.pass = arg;
      when '--trusted_sender'
        self.trusted_sender = arg;
      when '--senders_name'
        self.senders_name = arg;
      when '--relevant_keyword'
        self.relevant_keyword = arg;
      when '--num_keywords'
        self.num_keywords = arg;
      when '--accepted_file_extension'
        self.accepted_file_extension = arg;
      when '--suspicious_of_file_name'
        self.suspicious_of_file_name = arg;
      when '--reject_all'
        self.reject_all = arg;
    end
  end

end

PhishConfigGenerator.new.run
