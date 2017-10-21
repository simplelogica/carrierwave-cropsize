module Carrierwave::Cropsize
  class ImageCrop < ApplicationRecord
    belongs_to :image, inverse_of: :crops
    has_many :sizes, class_name: "Carrierwave::Cropsize::ImageCropSize", inverse_of: :image_crop

    mount_uploader :crop, ImageCropUploader

  end
end
