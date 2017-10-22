module Carrierwave::Cropsize
  class ImageCropUploader < ApplicationUploader

    process :resize_crop
    process :store_dimensions
    process :update_crop_sizes


    def resize_crop
      base_value = model.base_ratio_for_crop ::MiniMagick::Image.open(file.file)[:dimensions]
      resize_to_fill base_value * model.ratio_w, base_value * model.ratio_h
    end

    def store_dimensions
      model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions]
    end

    ##
    # Get the existing sizes and reupload the file
    def update_crop_sizes
      image_extension = (File.extname(original_filename) rescue nil)
      model.sizes.each do |crop_size|
        crop_size.crop = file
        crop_size.save!
      end
    end

  end
end
