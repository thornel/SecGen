#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_string_encoder.rb'
class IdorProductTemplateGenerator < StringEncoder
  attr_accessor :strings_to_leak
  attr_accessor :table_headings

  def initialize
    super
    self.module_name = 'IDOR Product Snippet Generator'
    self.strings_to_leak = ''
    self.table_headings = ''
  end

  def encode_all
    headings = "#{self.table_headings}"
    headings_array = headings.split(',')
    table_name = headings_array[0]
    name = headings_array[1]
    price = headings_array[2]
    img = headings_array[3]

    flag_statement = "<div class=\"alert alert-info\">
                            Well done, you have successfully exploited an insecure direct object reference vulnerability!<br/>
                            Here is a flag: #{strings_to_leak}
                          </div>"

    flag_check = "<?php
                    if ($max_id == $id) {
                    ?> <div>#{flag_statement}</div>
                    <?php } ?>"

    layout = "<?php
                if (isset($_GET['id'])){
                $id = $_GET['id'];
                $statement = \"SELECT * FROM #{table_name} WHERE ID = \".$id;
                $statement .= \"; SELECT MAX(ID) FROM #{table_name}\";
                if (mysqli_multi_query($conn2, $statement)) {
                      if ($result = mysqli_store_result($conn2)) {
                              $row = mysqli_fetch_array($result);
                              if (!empty($row)) {
                               ?>
                                 <div class=\"jumbotron\">
                                 <img src=\"<?php echo $row['#{img}']; ?>\" alt=\"image\" class=\"img-fluid\" />
                                 <div class=\"h2\"><?php echo $row['#{name}']; ?> <i class=\"sizes\">(Low Stock)</i></div>
                                 <div class=\"h3\">&pound;<?php echo $row['#{price}']; ?></div>
                                 </div>
                                 <?php
                              mysqli_free_result($result);
                              } else {
                                header('Location: not_found.php');
                              }
                      }
                      if (mysqli_more_results($conn2)) {
                          mysqli_next_result($conn2);
                          $result = mysqli_store_result($conn2);
                          $max_id = mysqli_fetch_row($result)[0];
                          ?> <div>#{flag_check}</div> <?php
                      }
                }
             }
           ?>"

    snippet = layout

    self.outputs << snippet
  end

  def get_options_array
    super + [['--table_headings', GetoptLong::REQUIRED_ARGUMENT],
             ['--strings_to_leak', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
    when '--table_headings'
      self.table_headings << arg;
    when '--strings_to_leak'
      self.strings_to_leak << arg;
    end
  end

  def encoding_print_string
    'table_headings: ' + self.table_headings.to_s + print_string_padding +
    'strings_to_leak: ' + self.strings_to_leak.to_s + print_string_padding
  end
end

IdorProductTemplateGenerator.new.run
