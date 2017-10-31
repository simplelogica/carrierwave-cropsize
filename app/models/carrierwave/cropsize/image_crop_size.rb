module Carrierwave::Cropsize
  class ImageCropSize < ApplicationRecord
    belongs_to :image_crop, inverse_of: :sizes
    mount_uploader :crop, ImageCropSizeUploader

    validates :width, presence: true

    # This accessor is set in image crop uploader update_crop_sizes method
    # We need it in order to keep the same extension in the image and crops
    attr_accessor :extra_extension

    def self.crop_size_url image_id, aspect_ratio, width, extension
      "uploads/image/#{image_id}/crops/#{aspect_ratio}/#{width}/image#{extension}"
    end

  end
end
