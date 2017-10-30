$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "carrierwave/cropsize/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "carrierwave-cropsize"
  s.version     = Carrierwave::Cropsize::VERSION
  s.authors     = ["David J. Brenes"]
  s.email       = ["davidjbrenes@gmail.com"]
  s.homepage    = "https://github.com/simplelogica/carrierwave-crop-size"
  s.summary     = "This engine allows to handle multiple kind of crops and sizes for an image without creating them by default, only when needed."
  s.description = "As an application grows you can need tens of differents crops and sizes for every image uploaded and you may end creating lots of image versions that are really not needed increasing the cost of storage and computaiton when uploading new images. This gem handles this problem."
  s.license     = "GPL"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"
  s.add_dependency "carrierwave", "~> 1.2.1"
  s.add_dependency "mini_magick", "~> 4.8.0"
  s.add_dependency 'sidekiq', '~> 4.1.0'
  s.add_dependency 'sidekiq-status', '~> 0.6.0'

  s.add_development_dependency "sqlite3"
end
