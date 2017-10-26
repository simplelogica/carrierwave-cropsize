module Carrierwave::Cropsize
  class ImageCropSizeUploader < ApplicationUploader

    process :resize_crop

    def resize_crop
      manipulate! do |img|
        img.resize model.width
      end
    end

    ##
    # We want the same path that the one created for the crop, but includng information about the size.
    def store_dir
      "uploads/image/#{model.image_crop.image_id}/crops/#{model.image_crop.aspect_ratio}/#{model.width}"
    end

    ##
    # We override the file name so we can avoid uploading a "banner.jpg" file that
    # gets blocked by Adblock or others
    def filename
      # This accessor is set in crop_uploader update_crop_sizes method
      # We need it in order to keep the same extension in the image, crops and crop sizes
      if !Carrierwave::Cropsize.override_filenames && original_filename
        super
      elsif model.extra_extension.present?
        "image#{model.extra_extension}"
      elsif model.image_crop
        model.image_crop[:crop]
      elsif original_filename
        "image#{File.extname(super)}"
      else
        "image.jpg"
      end
    end

  end
end
