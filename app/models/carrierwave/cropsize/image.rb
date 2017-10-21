module Carrierwave::Cropsize
  class Image < ApplicationRecord

    # Carrierwave uploader for images
    mount_uploader :image, ImageUploader

    has_many :crops, class_name: "Carrierwave::Cropsize::ImageCrop", inverse_of: :image

  end
end
