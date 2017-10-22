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
        current_crop.crop = file
        current_crop.save
      end
    end

  end
end
