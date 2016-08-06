module AssetsPublic
  def self.script?(line="")
    line.include?("<script>") && line.include?("</script>") && line.include?('src=')

  def self.extract_src_path(line="")
    line.scan(/src="([^"]*)"/).first.first
  end

  def self.run(path_html, path_css)
    html_file = ScrapCss.html_file(path_html)
    css_file = ScrapCss.css_file(path_css)
    css_clases = html_file.css_clases
    css_file.select_css(css_clases)
    css_file.save_select_css
    result = {css_class_used_size:html_file.css_clases.size}
  end
end

class AssetsPublic::Files
  def initialize(path=".")
    @htmls = Dir["#{path}/**/*.html"]
  end
  def self.resolve_path(path_file="", src="")
    hash = Hash.new(0)
    src.split("/").each{ |value| hash[value] += 1 }
    up_folder_times = hash[".."] + 1
    src.gsub!("../","")

    path_file_split = path_file.split("/")
    up_folder_times.times{ path_file_split.pop }
    "#{path_file_split.join('/')}/#{src}"
  end
  def htmls
    @htmls
  end
end

class AssetsPublic::Html
  def initialize(path="")
    @path = path
    @lines = IO.readlines(path)
  end

  def lines
    @lines
  end

  def scripts_path
    scripts_lines = @lines.select{|line| AssetsPublic::Html.script? line }
    scripts_lines.map{|script_line| AssetsPublic::Html.extract_src_path script_line  }
  end
end
#
# class AssetsPublic::Files
#   def initialize(path="")
#     @file_lines ||= IO.readlines(path)
#     @css_clases = []
#   end
#
#   def self.get_css_clases(str)
#     str.scan(/class="([^"]*)"/).flatten.map{|css| css.split(" ") }.flatten
#   end
#
#   def css_clases
#     return @css_clases unless @css_clases.empty?
#     @file_lines.each{ |line|
#       @css_clases << ScrapCss::Html.get_css_clases(line) if line =~ /class=/
#     }
#     @css_clases.flatten.uniq
#   end
# end
#
# class ScrapCss::Css
#   def initialize(path="", url="")
#     @url = url
#     @path = path
#     @css_parts = IO.read(path).split("\n\n") unless path =~ /.min./
#     @css_parts = self.unminify.split("\n\n") if path =~ /.min./
#     @css_parts_used = []
#   end
#
#   def unminify
#     _unminify = IO.read(@path)
#     .gsub(";",";\n  ")
#     .gsub("}","\n}\n\n\n")
#     .gsub("{","{\n  ")
#     .gsub(",",",\n")
#     .gsub("*/","*/\n")
#
#     # File.open("output.css", 'w+'){ |file| file.write(_unminify) }
#     _unminify
#   end
#
#   def get_urls
#     @css_parts.select{|a| a =~ /url\(/ }
#     .map{|css_part| css_part.scan(/url\(([^)]*)\)/) }
#     .flatten.uniq
#   end
#
#   def select_css(css_clases_useds)
#    css_clases_useds.each do |css_clase|
#       @css_parts.each do |css_part|
#         @css_parts_used << css_part if ScrapCss::Css.str_contain_css(css_part, css_clase)
#       end
#    end
#     @css_parts_used.uniq
#   end
#
#   def save_select_css
#     File.open("output.css", 'w+') do |file|
#       @css_parts_used.each{|css_clase_used| file.write("#{css_clase_used}\n\n")  }
#     end
#   end
#
#   def self.str_contain_css(str, css_class)
#     str.include?(".#{css_class} ") || str.include?(".#{css_class}.") || str.include?(".#{css_class}:")
#   end
# end
