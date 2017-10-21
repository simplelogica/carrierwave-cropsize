class CreateCarrierwaveCropsizeImageCrops < ActiveRecord::Migration[5.1]
  def change
    create_table :carrierwave_cropsize_image_crops do |t|
      t.string :crop

      t.integer :width
      t.integer :height

      t.string :aspect_ratio

      t.references :image, index: true

      t.timestamps
    end
  end
end
