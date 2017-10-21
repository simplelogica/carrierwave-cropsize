require 'carrierwave'
require 'mini_magick'

module Carrierwave
  module Cropsize
    class Engine < ::Rails::Engine
      isolate_namespace Carrierwave::Cropsize
    end
  end
end
