require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'rails-assets-public'
  s.version     = ScrapCss::VERSION
  s.executables << 'assets_public'
  s.date        = '2016-08-05'
  s.summary     = "AssetsPublic"
  s.description = "All javascript you in public move to vendor and requiere in aplication.js"
  s.authors     = ["Miguel Savignano"]
  s.email       = 'migue.masx@gmail.com'
  s.files       = ["lib/assets_public.rb"]
  s.homepage    =
    'https://github.com/MiguelSavignano/rails-assets-public'
  s.license       = 'MIT'
end
