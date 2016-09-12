require 'getoptlong'

# Inherited by local string encoders
# stdout used to return value
# use Print.local to print status messages (formatted to stdout)

class StringGenerator
  require_relative '../helpers/print.rb'

  attr_accessor :module_name
  attr_accessor :output

  # override this
  def initialize
    # default values
    self.module_name = 'Null generator'
  end

  # override this
  def generate
    self.output = 'Nothing to see here'
  end

  def read_arguments
    # Get command line arguments
    opts = GetoptLong.new(
        [ '--help', '-h', GetoptLong::NO_ARGUMENT ]
    )

    # process option arguments
    opts.each do |opt, arg|
      case opt
        when '--help'
          usage
        else
          Print.err "Argument not valid: #{arg}"
          usage
          exit
      end
    end
  end

  def usage
    Print.err "Usage:
   #{$0} [--options]

   OPTIONS:
     --strings_to_encode [string]
"
    exit
  end

  def run
    Print.local module_name

    read_arguments

    Print.local_verbose "Generating..."
    generate
    Print.local_verbose "Generated: #{self.output}"
    puts self.output
  end
end

