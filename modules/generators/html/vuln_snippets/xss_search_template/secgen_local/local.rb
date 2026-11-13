#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_string_encoder.rb'
class XSSsearchTemplateGenerator < StringEncoder
  attr_accessor :table_headings # 840 possibilities
  attr_accessor :difficulty # 4 possibilities
  attr_accessor :strings_to_leak
  attr_accessor :blacklist # 53,721,360 possibilities at 6 blacklist slots and 9,240 at 3

  # total possibilities around 1.6 Billion I think

  def initialize
    super
    self.module_name = 'XSS search Snippet Generator'
    self.table_headings = ''
    self.difficulty = ''
    self.strings_to_leak = ''
    self.blacklist = ''
  end

  def encode_all

    # uses html snippet generator as a base
    # headings input requried for generation, each heading split by a comma
    headings = "#{self.table_headings}"
    headings_array = headings.split(',')

    # used for headings, table name and column headings
    table_name = headings_array[0]
    # email heading
    name = headings_array[1]
    # price heading
    price = headings_array[2]
    #image headings
    img = headings_array[3]

    blacklist = "#{self.blacklist}"

    blacklist_insert = "\'" + blacklist
                                .split(',')
                                .sample(6)
                                .join("\',\'") + "\'"

    medium_blacklist_insert = "\'" + blacklist
                                       .split(',')
                                       .sample(3)
                                       .join("\',\'") + "\'"

    # The snippets of code below are taken from lauras code and edited slightly
    flag_statement = "$pattern = \"/<(?i)script>(confirm|prompt|alert)\\(([^'\\\"]*)\\);?<\\/script>/\";
                        if (preg_match($pattern, $search)){
                          ?>
                          <div class=\"alert alert-info\">
                            Well done, you have successfully exploited a cross-site scripting vulnerability!<br/>
                            Here is a flag: #{strings_to_leak}
                          </div>
                         <?php
                        }"

    vector_input = File.readlines("#{WS_ATTACK_DIR}/xss_stored/vectors/vector_1")
    vector = vector_input.join('')

    reflected_input = "$search= "
    reflected_input_with_blacklist = reflected_input + "str_replace($blacklist, \"\", $_POST['search']);"

    base_query = "$sql_query = \"SELECT *  FROM #{table_name}"
    where_clause = " WHERE #{name} LIKE '%\" .$search .\"%'"
    order_by = " ORDER BY ID LIMIT 6\";"
    default_db_query = base_query + order_by
    user_db_query = base_query + where_clause + order_by

    case difficulty
    when 'easy'
      reflected_input << "mysqli_real_escape_string($conn2, $_POST['search']);"
      process_request = reflected_input + user_db_query
    when 'medium'
      blacklist = "$blacklist = array(#{medium_blacklist_insert});"
      process_request = blacklist + reflected_input_with_blacklist + user_db_query
    when 'hard'
      blacklist = "$blacklist = array(#{blacklist_insert});"
      process_request = blacklist + reflected_input_with_blacklist + user_db_query
    else
      reflected_input << "htmlspecialchars(mysqli_real_escape_string($conn2, $_POST['search']));"
      process_request = reflected_input + user_db_query
    end

    submit = "<?php
                $result = mysqli_query($conn2, $sql_query);
                echo '<p id=\"success\">You searched for: '.$search.'<br>';
                #{flag_statement}
                while ($row=mysqli_fetch_assoc($result)){ ?>
                  <div class=\"product\">
                          <a href=\"/product.php?id=<?php echo $row['id']?>\">
                            <img src=\"<?php echo $row['#{img}']; ?>\" alt=\"shirt\" height=\"224px\" width=\"224px\" />
                            <div><?php echo $row['#{name}']; ?> <i class=\"sizes\">(Low Stock)</i></div>
                          </a>
                          <div>&pound;<?php echo $row['#{price}']; ?></div>
                          <div>
                             <form>
                              <input type=\"number\" name=\"quantity\" min=\"0\" max=\"5\" value=\"0\">
                              <input type=\"submit\" name=\"submit\" value=\"Add\">
                            </form>
                          </div>
                      </div>
                <?php } ?>"

    layout = "<div class=\"row\">
                <div class=\"col\-3\" id=\"left\-side\-columns\">
                    #{vector}
                  <?php if(isset($_POST['submit'])){
                            #{process_request}
                        } else {
                            #{default_db_query}
                        } ?>
                </div>
                <div class=\"col\-9\">
                  <div class=\"product-grid\">
                      #{submit}
                  </div>
                </div>
              </div>"

    snippet = layout

    self.outputs << snippet
  end

  def get_options_array
    super + [['--table_headings', GetoptLong::REQUIRED_ARGUMENT],
             ['--difficulty', GetoptLong::REQUIRED_ARGUMENT],
             ['--strings_to_leak', GetoptLong::REQUIRED_ARGUMENT],
             ['--blacklist', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
    when '--difficulty'
        self.difficulty << arg;
    when '--table_headings'
        self.table_headings << arg;
    when '--strings_to_leak'
        self.strings_to_leak << arg;
    when '--blacklist'
        self.blacklist << arg;
    end
  end


  def encoding_print_string
    'difficulty: ' + self.difficulty.to_s + print_string_padding +
    'table_headings: ' + self.table_headings.to_s + print_string_padding +
    'strings_to_leak: ' + self.strings_to_leak.to_s + print_string_padding +
    'blacklist: ' + self.blacklist.to_s
  end
end

XSSsearchTemplateGenerator.new.run
