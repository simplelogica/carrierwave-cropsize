module Carrierwave::Cropsize
  class MultipleCropSizeCreationWorker
    include Sidekiq::Worker

    sidekiq_options :queue => :crops

    ##
    # This method delegate to CropSizeCreationWorker
    def perform(image_ids, proportion, width)
      image_ids_with_crop = Carrierwave::Cropsize::Image.includes(crops: :sizes)
                                .where(
                                        id: image_ids,
                                        Carrierwave::Cropsize::ImageCrop.table_name => {aspect_ratio: proportion},
                                        Carrierwave::Cropsize::ImageCropSize.table_name => { width: width }
                                        )
                                .pluck(:id)
                                .uniq
      image_ids = image_ids - image_ids_with_crop
      image_ids.each do |image_id|
        begin
          CropSizeCreationWorker.new.perform image_id, proportion, width
        rescue
          # Try to repeat the crop size creation. We've been getting errors, although the crop creation it's not supposed to be asynchronous,
          # that the cropped image cannot be found and throws an exception, but works properly trying right after
          CropSizeCreationWorker.new.perform image_id, proportion, width
        end
      end
    end
  end
end
