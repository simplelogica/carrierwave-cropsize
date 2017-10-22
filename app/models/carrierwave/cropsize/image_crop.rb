module Carrierwave::Cropsize
  class ImageCrop < ApplicationRecord
    belongs_to :image, inverse_of: :crops
    has_many :sizes, class_name: "Carrierwave::Cropsize::ImageCropSize", inverse_of: :image_crop

    mount_uploader :crop, ImageCropUploader

    validates :aspect_ratio, presence: true

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

  end
end
