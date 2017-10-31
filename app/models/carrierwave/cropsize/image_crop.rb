module Carrierwave::Cropsize
  class ImageCrop < ApplicationRecord
    belongs_to :image, inverse_of: :crops
    has_many :sizes, class_name: "Carrierwave::Cropsize::ImageCropSize", inverse_of: :image_crop

    mount_uploader :crop, ImageCropUploader

    validates :aspect_ratio, presence: true

    # This accessor is set in image uploader update_crops method
    # We need it in order to keep the same extension in the image and crops
    attr_accessor :extra_extension

    ##
    # This accessor and the following after_save will allow us to modify the crop in an async way
    attr_accessor :async_crop_base64_remote_url

    after_save :async_upload_base64_crop

    ##
    # These method calculates the ratios that must be multiplied by the
    # dimensions of the crop being uploaded in order to get a crop with the
    # desired aspect ratio from the orginal image.
    def ratio_w
      width, height = aspect_ratio.split(':').map(&:to_f)

      if width >= height
        1
      else
        width / height
      end

    end

    def ratio_h
      width, height = aspect_ratio.split(':').map(&:to_f)

      if height >= width
        1
      else
        height / width
      end

    end

    ##
    # When generating the new image we need to have in mind the original dimensions
    def base_ratio_for_crop original_dimensions
      ratio_x, ratio_y = aspect_ratio.split(':').map(&:to_f)
      if ratio_x == ratio_y
        original_dimensions.min
      elsif ratio_x >= ratio_y  && original_dimensions[0]*ratio_h <= original_dimensions[1]
        original_dimensions[0]
      else
        [original_dimensions[1], ((original_dimensions[1]*ratio_x) / ratio_y ) ].max
      end
    end

    def self.crop_url image_id, aspect_ratio, extension
      "uploads/image/#{image_id}/crops/#{aspect_ratio}/image#{extension}"
    end

    ##
    # When we receive an async url of a base64 file then we create a worker to
    # update the crop and update its job id column
    def async_upload_base64_crop
      if async_crop_base64_remote_url
        job_id = Carrierwave::Cropsize:ImageCropUploadWorker.perform_async self.id, async_crop_base64_remote_url
        # we update the column avoiding any rails callback
        update_column :upload_job_id, job_id
        # and then store it in our model
        self.upload_job_id = job_id
      end
    end

  end
end
