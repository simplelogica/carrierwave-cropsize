class CreateCarrierwaveCropsizeImages < ActiveRecord::Migration[5.1]
  def change
    create_table :carrierwave_cropsize_images do |t|
      t.string :image

      t.timestamps
    end
  end
end
