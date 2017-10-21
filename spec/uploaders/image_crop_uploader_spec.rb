require 'spec_helper'


describe Carrierwave::Cropsize::ImageCropUploader do

    let(:image) { Carrierwave::Cropsize::Image.create! image: File.open(File.join(Carrierwave::Cropsize::Engine.root, image_path)) }
    let(:crop) { image.crops.create! crop: image.image }
    let(:image_path) { "spec/uploaders/assets/white.jpg" }

    context 'when creating a crop' do

      it 'should upload the file' do
        expect(crop.crop.file.extension).to eq "jpg"
      end
    end



end
