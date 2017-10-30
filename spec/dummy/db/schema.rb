# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171030160002) do

  create_table "carrierwave_cropsize_image_crop_sizes", force: :cascade do |t|
    t.integer  "image_crop_id"
    t.string   "crop"
    t.integer  "width"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["image_crop_id"], name: "index_carrierwave_cropsize_image_crop_sizes_on_image_crop_id"
  end

  create_table "carrierwave_cropsize_image_crops", force: :cascade do |t|
    t.string   "crop"
    t.integer  "width"
    t.integer  "height"
    t.string   "aspect_ratio"
    t.integer  "image_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["image_id"], name: "index_carrierwave_cropsize_image_crops_on_image_id"
  end

  create_table "carrierwave_cropsize_images", force: :cascade do |t|
    t.string   "image"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "upload_job_id"
  end

end
