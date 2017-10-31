require 'open-uri'
module Carrierwave::Cropsize
  ##
  # This worker will peform the actual upload of the crop and keep
  # status of how it all goes.
  class ImageCropUploadWorker
    include Sidekiq::Worker
    include Sidekiq::Status::Worker
    sidekiq_options :queue => :crops

    ##
    # This method performs the upload.
    #
    # It receives an image id and its content since we can't pass objects or
    # files through sidekiq. We can't even trust on the sidekiq server being in
    # the same server the image has been uploaded so we don't have access to the
    # same filesystem.
    def perform(crop_id, base64_url)

      at 0, "Configuring"
      crop = ImageCrop.find crop_id
      at 10, "Receiving the new crop."
      base64_file = open(base64_url)
      at 55, "Storing the new crop at S3."
      crop.update_attributes(crop: base64_file.read)
      store html_replacement: "<img src='#{crop.crop_url}?#{Time.now.to_i}' />"
      at 100, "crop uploaded and processed."
      crop.update_column(:upload_job_id, nil)

    end
  end
end
