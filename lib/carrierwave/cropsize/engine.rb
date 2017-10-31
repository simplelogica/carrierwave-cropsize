require 'carrierwave'
require 'carrierwave/base64'
require 'mini_magick'
require 'sidekiq'
require 'sidekiq-status'

module Carrierwave
  module Cropsize
    class Engine < ::Rails::Engine
      isolate_namespace Carrierwave::Cropsize
    end
  end
end
