require 'spec_helper'

describe Carrierwave::Cropsize::MultipleCropSizeCreationWorker do

  let(:image_1) { Carrierwave::Cropsize::Image.create! image: File.open(File.join(Carrierwave::Cropsize::Engine.root, image_1_path)) }
  let(:image_1_path) { "spec/uploaders/assets/horizontal.jpg" }
  let(:image_2) { Carrierwave::Cropsize::Image.create! image: File.open(File.join(Carrierwave::Cropsize::Engine.root, image_2_path)) }
  let(:image_2_path) { "spec/uploaders/assets/vertical.jpg" }
  let(:aspect_ratio) { "1:1" }
  let(:width) { 200 }
  let(:thumb_width) { 150 }

  context 'when asking for the crop arrays' do
    context 'concerning the sidekiq jobs' do

      before do
        Carrierwave::Cropsize::Image.get_crop_arrays([image_1, image_2], aspect_ratio, width)
      end

      it 'should create the worker when being asked for a crop' do
        expect(Carrierwave::Cropsize::MultipleCropSizeCreationWorker.jobs.size).to eq 1
      end

    end

    context 'concerning the crop sizes' do

      before do
        Sidekiq::Testing.inline!
        Carrierwave::Cropsize::Image.get_crop_arrays([image_1, image_2], aspect_ratio, width)
      end

      it 'should create the crop and the crop size required' do
        crop = image_1.crops.find_by(aspect_ratio: aspect_ratio)
        expect(crop).not_to be_nil
        crop_size = crop.sizes.find_by(width: width)
        expect(crop_size).not_to be_nil
        expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions]).to eq [width, width]

        crop = image_2.crops.find_by(aspect_ratio: aspect_ratio)
        expect(crop).not_to be_nil
        crop_size = crop.sizes.find_by(width: width)
        expect(crop_size).not_to be_nil
        expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions]).to eq [width, width]
      end

    end
  end

  context 'when asking for the crop hash' do
    context 'concerning the sidekiq jobs' do

      before do
        Carrierwave::Cropsize::Image.get_crop_hash([image_1, image_2], aspect_ratio, width, thumb_width)
      end

      it 'should create the worker when being asked for a crop' do
        expect(Carrierwave::Cropsize::MultipleCropSizeCreationWorker.jobs.size).to eq 2
      end

    end

    context 'concerning the crop sizes' do

      before do
        Sidekiq::Testing.inline!
        Carrierwave::Cropsize::Image.get_crop_hash([image_1, image_2], aspect_ratio, width, thumb_width)
      end

      it 'should create the crop and the crop size required' do
        crop = image_1.crops.find_by(aspect_ratio: aspect_ratio)
        expect(crop).not_to be_nil
        crop_size = crop.sizes.find_by(width: width)
        expect(crop_size).not_to be_nil
        expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions]).to eq [width, width]
        crop_size = crop.sizes.find_by(width: thumb_width)
        expect(crop_size).not_to be_nil
        expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions]).to eq [thumb_width, thumb_width]

        crop = image_2.crops.find_by(aspect_ratio: aspect_ratio)
        expect(crop).not_to be_nil
        crop_size = crop.sizes.find_by(width: width)
        expect(crop_size).not_to be_nil
        expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions]).to eq [width, width]
        crop_size = crop.sizes.find_by(width: thumb_width)
        expect(crop_size).not_to be_nil
        expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions]).to eq [thumb_width, thumb_width]

      end

    end
  end

end

