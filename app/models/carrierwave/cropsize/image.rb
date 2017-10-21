module Carrierwave::Cropsize
  class Image < ApplicationRecord

    # Carrierwave uploader for images
    mount_uploader :image, ImageUploader

  end
end
