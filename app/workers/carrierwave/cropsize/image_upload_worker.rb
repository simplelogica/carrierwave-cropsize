module Carrierwave::Cropsize
  # This worker will peform the actual upload of the image and keep
  # status of how it all goes.
  class ImageUploadWorker
    include Sidekiq::Worker
    include Sidekiq::Status::Worker

    sidekiq_options :queue => :images

      ##
      # This method performs the upload.
      #
      # It receives an image id and its content since we can't pass objects or
      # files through sidekiq. We can't even trust on the sidekiq server being in
      # the same server the image has been uploaded so we don't have access to the
      # same filesystem.
      def perform(image_id, image_url)

        at 0, "Configuring"
        image = Image.find image_id
        at 10, "Uploading to S3."
        if Gem::Version.new(Rails.version) > Gem::Version.new('6.0')
          image.update(remote_image_url: image_url)
        else
          image.update_attributes(remote_image_url: image_url)
        end
        at 100, "Image uploaded and processed."
        image.update_column(:upload_job_id, nil)
        store html_replacement: "<a href='#{image.image_url}'>#{image.image_url}</a>"

      end
    end

  end
