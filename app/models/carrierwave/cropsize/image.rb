module Carrierwave::Cropsize
  class Image < ApplicationRecord

    # Carrierwave uploader for images
    mount_uploader :image, ImageUploader

    has_many :crops, class_name: "Carrierwave::Cropsize::ImageCrop", inverse_of: :image

    attr_accessor :async_remote_image_url

    after_commit :async_upload_image

    ##
    # Method to find a crop for some aspect_ratio
    def crop_for proportion
      crops.find_by(aspect_ratio: proportion)
    end

    ##
    # Method to find a crop for some aspect_ratio and width
    def crop_size_for proportion, width
      crop = crop_for(proportion)
      return nil if crop.nil?
      crop.sizes.find_by(width: width)
    end


    ##
    # When we receive an async url then we create a worker to update the image
    # and update its job id column
    def async_upload_image
      if async_remote_image_url
        job_id = Carrierwave::Cropsize::ImageUploadWorker.perform_async self.id, async_remote_image_url
        # we update the column avoiding any rails callback
        update_column :upload_job_id, job_id
        # and then store it in our model
        self.upload_job_id = job_id
      end
    end

    ##
    # Get an array with two images. One cropped to size and ratio and the other only by ratio.
    def get_crop_array proportion, width
      return [] if self.image_url.nil?

      Carrierwave::Cropsize::CropSizeCreationWorker.perform_async(self.id, proportion, width) if crop_size_for(proportion, width).nil?

      base = self.image.asset_host
      [
        "#{base}/#{Carrierwave::Cropsize::ImageCropSize.crop_size_url(self.id, proportion, width, File.extname(self.image_url))}",
        "#{base}/#{Carrierwave::Cropsize::ImageCrop.crop_url(self.id, proportion, File.extname(self.image_url))}"
      ]
    end

    ##
    # This method get crop urls in hash format (image in several sizes) for a
    # collection of images and triggers the creation in a sidekiq worker
    def self.get_crop_hash images, proportion, width, thumb_width=220, original_width=nil, original_proportion=nil

      thumb_width ||= 220
      crops = {}
      image_ids = []
      base = self.new.image.asset_host

      images.each do |image|
        image_id = image.is_a?(Hash) ? image[:id] : image.id
        image_name = image.is_a?(Hash) ? image[:image] : image.image_url
        next if image_name.blank?
        extension = File.extname(image_name)
        crops[image_id] = {
          crop: "#{base}/#{Carrierwave::Cropsize::ImageCropSize.crop_size_url(image_id, proportion, width, extension)}",
          thumb: "#{base}/#{Carrierwave::Cropsize::ImageCropSize.crop_size_url(image_id, proportion, thumb_width, extension)}",
          original: original_width ? "#{base}/#{Carrierwave::Cropsize::ImageCropSize.crop_size_url(image_id, original_proportion || proportion, original_width, extension)}" : "#{base}/uploads/image/#{image_id}/#{image_name}"
        }
        image_ids << image_id
      end

      Carrierwave::Cropsize::MultipleCropSizeCreationWorker.perform_async(image_ids, proportion, width)
      Carrierwave::Cropsize::MultipleCropSizeCreationWorker.perform_async(image_ids, proportion, thumb_width)
      Carrierwave::Cropsize::MultipleCropSizeCreationWorker.perform_async(image_ids, original_proportion || proportion, original_width) if original_width

      crops

    end

    ##
    # This method get crop urls for a collection of images and triggers the
    # creation in a sidekiq worker
    def self.get_crop_arrays images, proportion, width

      crops = {}
      image_ids = []
      base = self.new.image.asset_host

      images.each do |image|
        image_id = image.is_a?(Hash) ? image[:id] : image.id
        image_name = image.is_a?(Hash) ? image[:image] : image.image_url
        next if image_name.blank?
        extension = File.extname(image_name)
        crops[image_id] = [
          "#{base}/#{Carrierwave::Cropsize::ImageCropSize.crop_size_url(image_id, proportion, width, extension)}",
          "#{base}/#{Carrierwave::Cropsize::ImageCrop.crop_url(image_id, proportion, extension)}"
        ]
        image_ids << image_id
      end

      Carrierwave::Cropsize::MultipleCropSizeCreationWorker.perform_async(image_ids, proportion, width)

      crops

    end


  end
end
