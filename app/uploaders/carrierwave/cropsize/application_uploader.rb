module Carrierwave::Cropsize
  class ApplicationUploader < CarrierWave::Uploader::Base

    include CarrierWave::MiniMagick

    storage Carrierwave::Cropsize.storage

  end
end
