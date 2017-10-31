module Carrierwave::Cropsize
  class CropSizeCreationWorker
    include Sidekiq::Worker

    sidekiq_options :queue => :crops

    ##
    # This method performs the creation of the new crop size
    def perform(image_id, proportion, width)

      image = Image.find image_id
      if image
        crop = image.crops.find_by(aspect_ratio: proportion)
        crop ||= image.crops.create!(aspect_ratio: proportion, crop: image.image)
        crop_size = crop.sizes.find_by(width: width)

        if crop_size.nil?
          begin
            crop_size = crop.sizes.create!(width: width, crop: crop.crop)
          rescue
            #Try to repeat the crop size creation. We've been getting errors, although the crop creation it's not supposed to be asynchronous,
            #that the cropped image cannot be found and throws an exception, but works properly trying right after
            crop_size = crop.sizes.create!(width: width, crop: crop.crop)
          end
        end
      end
    end
  end
end
