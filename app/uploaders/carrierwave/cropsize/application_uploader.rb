module Carrierwave::Cropsize
  class ApplicationUploader < CarrierWave::Uploader::Base

    include CarrierWave::MiniMagick

    storage Carrierwave::Cropsize.storage

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

  end
end
