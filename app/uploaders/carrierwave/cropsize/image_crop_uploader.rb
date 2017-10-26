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
      image_extension = if model.extra_extension.present?
          model.extra_extension
        elsif model.image && !model.image[:image].blank?
          model.image[:image]
        else
          File.extname(original_filename) rescue nil
        end

      model.sizes.each do |crop_size|
        crop_size.extra_extension = image_extension
        crop_size.crop = file
        crop_size.save!
      end
    end

    # We want the image id, not the crop one. For identfying the crop we will
    # use the aspect_ratio. This way the paths will be predictible.
    def store_dir
      "uploads/image/#{model.image_id}/#{mounted_as.to_s.pluralize}/#{model.aspect_ratio}"
    end

    ##
    # We override the file name so we can avoid uploading a "banner.jpg" file that
    # gets blocked by Adblock or others
    def filename
      if !Carrierwave::Cropsize.override_filenames && original_filename
        super
      elsif model.extra_extension.present?
        "image#{model.extra_extension}"
      elsif model.image && !model.image[:image].blank?
        model.image[:image]
      elsif original_filename
        "image#{File.extname(super)}"
      else
        "image.jpg"
      end
    end

  end
end
