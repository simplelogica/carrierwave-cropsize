class AddUploadJobIdToCarrierwaveCropsizeImage < ActiveRecord::Migration[5.0]
  def change
    add_column :carrierwave_cropsize_images, :upload_job_id, :string
  end
end
