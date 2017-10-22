require 'spec_helper'


describe Carrierwave::Cropsize::ImageUploader do

    let(:image) { Carrierwave::Cropsize::Image.create! image: File.open(File.join(Carrierwave::Cropsize::Engine.root, image_path)) }
    let(:image_path) { "spec/uploaders/assets/horizontal.jpg" }

    context 'when creating an image' do

      it 'should upload the file' do
        expect(image.image.file.extension).to eq "jpg"
      end

      it 'should keep the same size' do
        expect(::MiniMagick::Image.open(image.image.file.path)[:dimensions]).to eq [1920, 1200]
      end
    end

    context 'when replacing the file' do

      let(:image2_path) { File.join(Carrierwave::Cropsize::Engine.root, "spec/uploaders/assets/vertical.jpg") }

      it "should change the dimensions" do
        expect(image.image.file.extension).to eq "jpg"

        image.image = File.open(image2_path)
        image.save

        expect(::MiniMagick::Image.open(image.image.file.path)[:dimensions]).to eq [1200, 1920]
      end

    end



end
