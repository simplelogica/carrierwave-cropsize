module Carrierwave::Cropsize
  class ImageCropSizeUploader < ApplicationUploader

    process :resize_crop

    def resize_crop
      manipulate! do |img|
        img.resize model.width
      end
    end

  end
end
