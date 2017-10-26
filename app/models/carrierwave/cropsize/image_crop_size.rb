module Carrierwave::Cropsize
  class ImageCropSize < ApplicationRecord
    belongs_to :image_crop, inverse_of: :sizes
    mount_uploader :crop, ImageCropSizeUploader

    validates :width, presence: true

    # This accessor is set in image crop uploader update_crop_sizes method
    # We need it in order to keep the same extension in the image and crops
    attr_accessor :extra_extension

  end
end
