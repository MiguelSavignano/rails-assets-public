require 'assets_public'
require 'pry'
describe "AssetsPublic" do
  it ".script?" do
    r = AssetsPublic.script?('"<script src="../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js"></script>"')
    expect(r).to eq(true)
  end
  it ".extract_src_path" do
    r = AssetsPublic.extract_src_path('"<script src="../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js"></script>"')
    expect(r).to eq('../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js')
  end
  it ".extract_src_path" do
    r = AssetsPublic.extract_src_path("<script src='../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js'></script>")
    expect(r).to eq('../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js')
  end
  it ".run" do
    r = AssetsPublic.run("spec/fixture/public/app", "spec/fixture/vendor")
    expect(r[:html_files].size).to eq(74)
    expect(r[:scripts_paths].size).to eq(94)
    expect(r[:scripts_http].size).to eq(5)
  end

end

describe "AssetsPublic::Files" do
  it "initialize" do
    files = AssetsPublic::Files.new("spec/fixture/public/app")
    expect(files.htmls).to include("spec/fixture/public/app/index.html")
  end
  it ".resolve_path" do
    r = AssetsPublic::Files.resolve_path(
      'spec/fixture/public/app/index.html',
      '../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js'
    )
    expect(r).to eq('spec/fixture/public/plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js')
  end
  it ".resolve_path" do
    r = AssetsPublic::Files.resolve_path(
      'spec/fixture/public/app/index.html',
      'js/dashboard1.js'
    )
    expect(r).to eq('spec/fixture/public/app/js/dashboard1.js')
   end
  # it ".move_copy_file" do
  #   r = AssetsPublic::Files.move_copy_file(
  #     'spec/fixture/public/app/js/custom.js',
  #     'spec/fixture/vendor/'
  #   )
  #   expect(r).to eq("")
  #  end
end

describe "AssetsPublic::Html" do
  it "initialize" do
    html = AssetsPublic::Html.new("spec/fixture/public/app/index.html")
    expect(html.lines.size).to eq(544)
  end
  it "#scripts_lines" do
    html = AssetsPublic::Html.new("spec/fixture/public/app/index.html")
    expect(html.scripts_lines.size)
    .to eq(18)
  end
  it "#scripts_paths" do
    html = AssetsPublic::Html.new("spec/fixture/public/app/index.html")
    expect(html.scripts_paths)
    .to include("spec/fixture/public/plugins/bower_components/jquery/dist/jquery.min.js")
  end
end
