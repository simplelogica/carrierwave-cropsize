module Carrierwave::Cropsize
  class ImageCrop < ApplicationRecord
    belongs_to :image, inverse_of: :crops
  end
end
