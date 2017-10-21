class CreateCarrierwaveCropsizeImageCropSizes < ActiveRecord::Migration[5.1]
  def change
    create_table :carrierwave_cropsize_image_crop_sizes do |t|
      t.belongs_to :image_crop, index: true
      t.string :crop
      t.integer :width

      t.timestamps
    end
  end
end
