require 'spec_helper'
require 'uri'

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

    context "regarding extensions" do
      let(:image_path) { File.join(Carrierwave::Cropsize::Engine.root, "spec/uploaders/assets/horizontal.jpg") }
      let(:image2_path) { File.join(Carrierwave::Cropsize::Engine.root, "spec/uploaders/assets/horizontal.png") }

      let(:image) { Carrierwave::Cropsize::Image.create! image: File.open(image_path) }
      let(:image2) { Carrierwave::Cropsize::Image.create! image: File.open(image2_path) }

      let(:aspect_ratio) { "200:300" }

      let(:crop) { image.crops.create!(aspect_ratio: aspect_ratio, crop: image.image ) }
      let(:crop2) { image2.crops.create!(aspect_ratio: aspect_ratio, crop: image2.image ) }

      let!(:crop_size) { crop.sizes.create! width: crop_width, crop: crop.crop.file  }
      let(:crop_size2) { crop2.sizes.create! width: crop_width, crop: crop.crop.file  }

      it "should have the same extension as the image" do
        expect(crop_size.crop.file.extension).to eq "jpg"
        expect(crop_size2.crop.file.extension).to eq "png"
      end

      it "should change the crop extension when image changes" do
        image.image =  File.open(image2_path)
        image.save
        expect(crop_size.reload.crop.file.extension).to eq "png"
        expect(image.image.file.extension).to eq "png"
      end

      it "should set the properly extension even when try to asign different one to a crop" do
        expect(crop.crop.file.extension).to eq "jpg"

        crop.crop = File.open(image2_path)
        crop.save

        expect(crop.crop.file.extension).to eq "jpg"
        expect(crop_size.crop.file.extension).to eq "jpg"
      end
    end


    context "regarding the path" do

      it "should be predictable" do
        expect(URI.unescape(crop_size.crop.url)).to eq "/uploads/image/#{image.id}/crops/#{aspect_ratio}/#{crop_width}/image.jpg"
      end

    end

end
