module Carrierwave::Cropsize
  class Image < ApplicationRecord

    # Carrierwave uploader for images
    mount_uploader :image, ImageUploader

    has_many :crops, class_name: "Carrierwave::Cropsize::ImageCrop", inverse_of: :image

    attr_accessor :async_remote_image_url

    after_commit :async_upload_image

    ##
    # When we receive an async url then we create a worker to update the image
    # and update its job id column
    def async_upload_image
      if async_remote_image_url
        job_id = Carrierwave::Cropsize::ImageUploadWorker.perform_async self.id, async_remote_image_url
        # we update the column avoiding any rails callback
        update_column :upload_job_id, job_id
        # and then store it in our model
        self.upload_job_id = job_id
      end
    end

  end
end
