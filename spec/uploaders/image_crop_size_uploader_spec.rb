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

    context 'when replacing the original image' do

      let(:aspect_ratio) { "1400:700" }
      let(:image2_path) { File.join(Carrierwave::Cropsize::Engine.root, "spec/uploaders/assets/vertical.jpg") }

      it "should change the dimensions" do
        # This should create the crop size from the default iamge (the horizontal one)
        crop_size

        # Here we check the dimensions. These should be the same as in the "uploading horizontal image" spec
        expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions]).to eq [crop_width, crop_width*960/1920]

        image.image = File.open(image2_path)
        image.save

        # Here we check again the dimensions. But these should be the same as in the "uploading vertical image" spec
        expect(::MiniMagick::Image.open(crop_size.crop.file.path)[:dimensions]).to eq [crop_width, 150]
      end

    end

end
