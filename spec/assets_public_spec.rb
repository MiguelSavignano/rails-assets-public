require 'assets_public'
require 'pry'
describe "AssetsPublic::Files" do
  it "initialize" do
    files = AssetsPublic::Files.new("spec/fixture/public/app")
    expect(files.htmls).to include("spec/fixture/public/app/index.html")
  end
  it ".script?" do
    r = AssetsPublic.script?('"<script src="../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js"></script>"')
    expect(r).to eq(true)
  end
  it ".extract_src_path" do
    r = AssetsPublic.extract_src_path('"<script src="../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js"></script>"')
    expect(r).to eq('../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js')
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
  it ".resolve_path" do
    r = AssetsPublic::Files.move_copy_file(
      'spec/fixture/public/app/js/custom.js',
      'spec/fixture/vendor/'
    )
    expect(r).to eq("")
   end
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
  it "#scripts_path" do
    html = AssetsPublic::Html.new("spec/fixture/public/app/index.html")
    expect(html.scripts_path)
    .to include("spec/fixture/public/plugins/bower_components/jquery/dist/jquery.min.js")
  end
end
