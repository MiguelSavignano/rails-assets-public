require 'assets_public'
require 'pry'
describe "AssetsPublic::Files" do
  it "initialize" do
    files = AssetsPublic::Files.new("spec/fixture/public/app")
    expect(files.htmls.size)
    .to eq(74)
  end
end

describe "AssetsPublic::Html" do
  it "initialize" do
    html = AssetsPublic::Html.new("spec/fixture/public/app/index.html")
    expect(html.lines.size)
    .to eq(544)
  end
  it ".script?" do
    r = AssetsPublic::Html.script?('"<script src="../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js"></script>"')
    expect(r)
    .to eq(true)
  end
  it ".extract_src_path" do
    r = AssetsPublic::Html.extract_src_path('"<script src="../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js"></script>"')
    expect(r)
    .to eq('../plugins/bower_components/jquery-sparkline/jquery.charts-sparkline.js')
  end
end
