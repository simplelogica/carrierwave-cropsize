module Carrierwave::Cropsize
  class ImageCropUploader < ApplicationUploader

    process :resize_crop
    process :store_dimensions


    def resize_crop
      base_value = model.base_ratio_for_crop ::MiniMagick::Image.open(file.file)[:dimensions]
      resize_to_fill base_value * model.ratio_w, base_value * model.ratio_h
    end

    def store_dimensions
      model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions]
    end

  end
end
