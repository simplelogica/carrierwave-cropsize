require 'spec_helper'


describe Carrierwave::Cropsize::ImageCropSizeUploader do

    let(:image) { Carrierwave::Cropsize::Image.create! image: File.open(File.join(Carrierwave::Cropsize::Engine.root, image_path)) }
    let(:crop) { image.crops.create!(aspect_ratio: aspect_ratio, crop: image.image.file ) }
    let(:aspect_ratio) { "1:1" }
    let(:crop_size) { crop.sizes.create! width: crop_width, crop: crop.crop.file  }
    let(:crop_width) { 300 }
    let(:image_path) { "spec/uploaders/assets/horizontal.jpg" }

    context 'when creating a crop size' do

      it 'should upload the file' do
        expect(crop_size.crop.file.extension).to eq "jpg"
      end

      it 'should change the size size' do
        expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions].first).to eq crop_width
      end

    end



end
