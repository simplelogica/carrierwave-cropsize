module Carrierwave::Cropsize
  class ImageCropSize < ApplicationRecord
    belongs_to :image_crop, inverse_of: :sizes

  end
end
