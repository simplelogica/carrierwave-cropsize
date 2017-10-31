class AddUploadJobIdToCarrierwaveCropsizeImageCrop < ActiveRecord::Migration[5.0]
  def change
    add_column :carrierwave_cropsize_image_crops, :upload_job_id, :string
  end
end
