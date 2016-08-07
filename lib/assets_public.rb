module AssetsPublic
  def self.script?(line="")
    line.include?("<script") && line.include?("</script>") && line.include?('src=')
  end

  def self.extract_src_path(line="")
    src_path = line.scan(/src="([^"]*)"/).first || line.scan(/src='([^"]*)'/).first
    src_path.first || ""
  end

  def self.run(app_folder="./public", vendor_folder="./vendor")
    files = AssetsPublic::Files.new(app_folder)
    htmls = files.htmls.map{|html_path| AssetsPublic::Html.new(html_path) }
    scripts_paths = htmls.map(&:scripts_paths).flatten.uniq
    scripts_paths.each{ |script_path|
      AssetsPublic::Files.move_copy_file(script_path, vendor_folder)
    }
    result = {
      html_files: files.htmls,
      scripts_paths: scripts_paths,
      scripts_http: htmls.map(&:scripts_http).flatten.uniq
    }
  end
end

class AssetsPublic::Files
  def initialize(path=".")
    @htmls = Dir["#{path}/**/*.html"]
  end

  def self.resolve_path(path_file="", src="")
    hash = Hash.new(0)
    src.split("/").each{ |value| hash[value] += 1 }
    up_folder_times = hash[".."] + 1 # plus one because you are in a file alway up one level
    src.gsub!("../","")

    path_file_split = path_file.split("/")
    up_folder_times.times{ path_file_split.pop }
    "#{path_file_split.join('/')}/#{src}"
  end

  def self.move_copy_file(file_path="", to_folder_path="")
    `cp #{file_path} #{to_folder_path}`
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

  def scripts_lines
    @scripts_lines ||= lines.select{|line| AssetsPublic.script? line }
  end

  def scripts_http
    @scripts_http ||= scripts_lines.select{ |scripts_line|
      scripts_line.include?("https:/") || scripts_line.include?("http:/")
    }
  end

  def scripts_paths
    scripts_paths = scripts_lines.map do |script_line|
      src_path = AssetsPublic.extract_src_path(script_line)
      AssetsPublic::Files.resolve_path(@path, src_path) unless src_path.include?("https:/") || src_path.include?("http:/")
    end
    scripts_paths.compact
  end
end
