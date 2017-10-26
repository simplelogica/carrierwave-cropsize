module Carrierwave::Cropsize
  class ImageUploader < ApplicationUploader

    process :update_crops

    ##
    # Get the existing crops of an image and upload them the file just uploaded.
    # THis way all the crops and (recursively) all the crop sizes can be
    # recreated.
    def update_crops
      image_extension = (File.extname(filename) rescue nil)
      model.crops.each do |current_crop|
        current_crop.extra_extension = image_extension
        current_crop.crop = file
        current_crop.save
      end
    end

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/image/#{model.id}"
    end

    ##
    # We override the file name so we can avoid uploading a "banner.jpg" file that
    # gets blocked by Adblock or others
    def filename
      if Carrierwave::Cropsize.override_filenames && original_filename
        "image#{File.extname(super)}"
      else
        super
      end
    end

  end
end
