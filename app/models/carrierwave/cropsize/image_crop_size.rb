module Carrierwave::Cropsize
  class ImageCropSize < ApplicationRecord
    belongs_to :image_crop, inverse_of: :sizes
    mount_uploader :crop, ImageCropSizeUploader

    validates :width, presence: true

  end
end
