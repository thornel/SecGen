#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_string_encoder.rb'

#noinspection SpellCheckingInspection
class SQLiTemplateGenerator < StringEncoder
  attr_accessor :table_headings
  attr_accessor :difficulty

  def initialize
    super
    self.module_name = 'SQLi Snippet Generator'
    self.table_headings = ''
    self.difficulty = ''
  end

  def encode_all
    #Ensure the difficulty is set correctly
    set_difficulty

    #Formatting: table headings for database
    headings = "#{self.table_headings}"
    headings_array = headings.split(',')
    @table_name = @question_column = headings_array[0]
    @name_column = headings_array[1]

    #Query: input of table headings to differentiate queries, these are queries from lauras code but used as a template here
    query_1 = "$statement = \"INSERT INTO #{@table_name} (#{headings}) VALUES" + "('$question','$name', '$mobile', '$email')\";"
    query_2 = "$statement = \"INSERT INTO #{@table_name} (#{@question_column}, #{@name_column}) VALUES ('$question', '$name')\";"

    #Input: Attack vector definition
    vector_1 = "#{WS_ATTACK_DIR}/sqli/vectors/vector_1"
    vector_2 = "#{WS_ATTACK_DIR}/sqli/vectors/vector_2"

    #Vulnerabilities
    vuln_option_1 = difficulty == 'impossible' ? 'vuln1' : %w{vuln_1 vuln_2 vuln_3}.sample
    vuln_option_2 = difficulty == 'impossible' ? 'vuln_2' : %w{vuln_4 vuln_5}.sample
    vuln_root_directory = "#{WS_ATTACK_DIR}/sqli/vulnerabilities/#{difficulty}/"

    #Generate different SQLi snippets
    option_1 = SnippetOption.new("POST",
                                 query_1,
                                 File.read(vector_1, chomp: true),
                                 File.read(vuln_root_directory + vuln_option_1, chomp: true))
    option_2 = SnippetOption.new("GET",
                                 query_2,
                                 File.read(vector_2, chomp: true),
                                 File.read(vuln_root_directory + vuln_option_2, chomp: true))

    #Choose a random snippet and generate the PHP code
    self.outputs << get_php_code([option_1, option_2].sample)

  end

  #Abstract PHP generation away from the main Ruby code
  def get_php_code(snippet_option)
    submit = "
        if (mysqli_query($conn2, $statement)){
        ?><div class=\"col-12\"id=\"success\">Thank you <?php echo $name;?> for your Review!</div>
        <?php
         }
     }
     ?>"

    heading = "<div class=\"row\"><h3>Please leave us a Review!</h3></div>\n"

    query_concat = "<?php\nif(isset($_#{snippet_option.method}['go'])){ \n#{snippet_option.vuln_template}#{snippet_option.query}\n#{submit}"

    submit_output = "
    <div class=\"row\">
        <h3>Other reviews</h3><br />
          <?php
          	$statement2 = \"SELECT * FROM #{@table_name}\";
          	$result = mysqli_query($conn2, $statement2);
          	while ($row = mysqli_fetch_assoc($result)){
              ?>
              <div class=\"other-review\">
                <div><?php echo $row['#{@question_column}']; ?></div>
                <div id=\"left-by\"><?php echo $row['#{@name_column}']; ?></div>
              </p>
            </div>
              <?php
          	}
          ?>
    </div>"

    heading << snippet_option.vector_template << "\n" << query_concat << "\n" << submit_output
  end

  #Inner class representing a snippet vulnerable to SQL injection
  class SnippetOption
    attr_accessor :method, :query, :vector_template, :vuln_template

    def initialize(method, query, vector_template, vuln_template)
      @method = method
      @query = query
      @vector_template = vector_template
      @vuln_template = vuln_template
    end

  end

  def get_options_array
    super + [['--table_headings', GetoptLong::REQUIRED_ARGUMENT],
             ['--difficulty', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
    when '--difficulty'
      self.difficulty << arg;
    when '--table_headings'
      self.table_headings << arg;
    end
  end

  def encoding_print_string
    'difficulty: ' + self.difficulty.to_s + print_string_padding +
      'table_headings: ' + self.table_headings.to_s
  end

  def set_difficulty
    difficulties = %w{easy medium hard impossible}
    unless difficulties.include? self.difficulty
      self.difficulty = difficulties.sample
    end
  end
end

SQLiTemplateGenerator.new.run
