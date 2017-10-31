require 'spec_helper'

describe Carrierwave::Cropsize::CropSizeCreationWorker do

  let(:image) { Carrierwave::Cropsize::Image.create! image: File.open(File.join(Carrierwave::Cropsize::Engine.root, image_path)) }
  let(:image_path) { "spec/uploaders/assets/horizontal.jpg" }
  let(:aspect_ratio) { "1:1" }
  let(:width) { 200 }

  context 'concerning the sidekiq jobs' do

    before do
      image.get_crop_array(aspect_ratio, width)
    end

    it 'should create the worker when being asked for a crop' do
      expect(Carrierwave::Cropsize::CropSizeCreationWorker.jobs.size).to eq 1
    end

  end

  context 'concerning the crop sizes' do

    before do
      Sidekiq::Testing.inline!
      image.get_crop_array(aspect_ratio, width)
    end

    it 'should create the crop and the crop size required' do
      crop = image.crops.find_by(aspect_ratio: aspect_ratio)
      expect(crop).not_to be_nil
      crop_size = crop.sizes.find_by(width: width)
      expect(crop_size).not_to be_nil
      expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions]).to eq [200, 200]
    end

  end


end

