module Carrierwave::Cropsize
  class ImageCrop < ApplicationRecord
    belongs_to :image, inverse_of: :crops

    mount_uploader :crop, ImageCropUploader

  end
end
