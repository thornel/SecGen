#!/usr/bin/ruby
require "base64"
require_relative '../../../../../../lib/objects/local_string_encoder.rb'

class InsecureCookieTemplateGenerator < StringEncoder
  attr_accessor :difficulty
  attr_accessor :strings_to_leak
  attr_accessor :default_superuser_role
  attr_accessor :default_user_role

  def initialize
    super
    self.module_name = 'Insecure Cookie Snippet Generator'
    self.difficulty = ''
    self.strings_to_leak = ''
    self.default_superuser_role = ''
    self.default_user_role = ''
  end

  def encode_all

    flag_statement = "<div class=\"alert alert-info\">
                          Well done, you have successfully exploited an insecure cookie vulnerability!<br/>
                          Here is a flag: #{strings_to_leak}
                        </div>"

    layout = "<div>
                <?php
                  $cookie_name = 'RBAC';
                  if (!isset($_COOKIE[$cookie_name])) {
                    setcookie($cookie_name, \"#{get_user_cookie}\");
                  } else {
                    $cookie = $_COOKIE[$cookie_name];
                    if ($cookie == \"#{get_superuser_cookie}\") {
                      ?> #{flag_statement} <?php
                    }
                  }
                ?>
             </div>"

    snippet = layout

    self.outputs << snippet
  end

  def get_cookie (role)
    cookie = "Role=#{role}"

    case difficulty
    when "medium"
      cookie = Base64.strict_encode64(cookie)
    when "hard"
      cookie = Base64.strict_encode64(Base64.strict_encode64(cookie))
    end
    return cookie
  end

  def get_user_cookie
    get_cookie default_user_role
  end

  def get_superuser_cookie
    get_cookie default_superuser_role
  end

  def get_options_array
    super + [['--default_superuser_role', GetoptLong::REQUIRED_ARGUMENT],
             ['--default_user_role', GetoptLong::REQUIRED_ARGUMENT],
             ['--difficulty', GetoptLong::REQUIRED_ARGUMENT],
             ['--strings_to_leak', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
    when '--difficulty'
      self.difficulty << arg;
    when '--default_superuser_role'
      self.default_superuser_role << arg;
    when '--default_user_role'
      self.default_user_role << arg;
    when '--strings_to_leak'
      self.strings_to_leak << arg;
    end
  end

  def encoding_print_string
      'difficulty: ' + self.difficulty.to_s + print_string_padding +
      'default_superuser_role: ' + self.default_superuser_role.to_s + print_string_padding +
      'default_user_role: ' + self.default_user_role.to_s + print_string_padding +
      'strings_to_leak: ' + self.strings_to_leak.to_s + print_string_padding
  end
end

InsecureCookieTemplateGenerator.new.run
