require 'spec_helper'
require 'uri'

describe Carrierwave::Cropsize::ImageCropUploader do

    let(:image) { Carrierwave::Cropsize::Image.create! image: File.open(File.join(Carrierwave::Cropsize::Engine.root, image_path)) }
    let(:crop) { image.crops.create!(aspect_ratio: aspect_ratio, crop: image.image.file ) }
    let(:aspect_ratio) { "1:1" }
    let(:image_path) { "spec/uploaders/assets/horizontal.jpg" }

    context 'when creating a crop' do

      it 'should upload the file' do
        expect(crop.crop.file.extension).to eq "jpg"
      end

    end

    context 'when creating crops' do

      context 'from a horizontal image' do

        # 1900 x 1200
        let(:image_path) { "spec/uploaders/assets/horizontal.jpg" }

        context 'creating a horizontal crop' do

          let(:aspect_ratio) { "1400:700" }

          it "should create it with the right dimensions" do
            expect(crop.width).to eq 1920
            expect(crop.height).to eq 960
          end

        end

        context 'creating a vertical crop' do

          let(:aspect_ratio) { "700:1400" }

          it "should create it with the right dimensions" do
            expect(crop.width).to eq 600
            expect(crop.height).to eq 1200
          end

        end

        context 'creating a squared crop' do

          let(:aspect_ratio) { "700:700" }

          it "should create it with the right dimensions" do
            expect(crop.width).to eq 1200
            expect(crop.height).to eq 1200
          end

        end

      end

      context 'from a vertical image' do

        # 1900 x 1200
        let(:image_path) { "spec/uploaders/assets/vertical.jpg" }

        context 'creating a horizontal crop' do

          let(:aspect_ratio) { "1400:700" }

          it "should create it with the right dimensions" do
            expect(crop.width).to eq 1200
            expect(crop.height).to eq 600
          end

        end

        context 'creating a vertical crop' do

          let(:aspect_ratio) { "700:1400" }

          it "should create it with the right dimensions" do
            expect(crop.width).to eq 960
            expect(crop.height).to eq 1920
          end

        end

        context 'creating a squared crop' do

          let(:aspect_ratio) { "700:700" }

          it "should create it with the right dimensions" do
            expect(crop.width).to eq 1200
            expect(crop.height).to eq 1200
          end

        end

      end

      context 'from an image that cannot fulfill the new required dimensions' do

        # 1900 x 1200
        let(:image_path) { "spec/uploaders/assets/small-horizontal.jpg" }

        context 'creating a horizontal crop' do

          let(:aspect_ratio) { "1600:610" }

          it "should create it with the right dimensions" do
            expect(crop.height).to eq 630
            expect(crop.width).to eq 1652
          end

        end
      end
    end

    context 'when replacing the original image' do

      let(:aspect_ratio) { "1400:700" }
      let(:image2_path) { File.join(Carrierwave::Cropsize::Engine.root, "spec/uploaders/assets/vertical.jpg") }

      it "should change the dimensions" do
        # This should create the crop from the default iamge (the horizontal one)
        crop

        # Here we check the dimensions. These should be the same as in the "uploading horizontal image" spec
        expect(crop.width).to eq 1920
        expect(crop.height).to eq 960

        image.image = File.open(image2_path)
        image.save

        # Here we check again the dimensions. But these should be the same as in the "uploading vertical image" spec
        expect(crop.width).to eq 1200
        expect(crop.height).to eq 600
      end

    end

    context "regarding extensions" do
      let(:image_path) { File.join(Carrierwave::Cropsize::Engine.root, "spec/uploaders/assets/horizontal.jpg") }
      let(:image2_path) { File.join(Carrierwave::Cropsize::Engine.root, "spec/uploaders/assets/horizontal.png") }

      let(:image) { Carrierwave::Cropsize::Image.create! image: File.open(image_path) }
      let(:image2) { Carrierwave::Cropsize::Image.create! image: File.open(image2_path) }

      let(:aspect_ratio) { "200:300" }

      let!(:crop) { image.crops.create!(aspect_ratio: aspect_ratio, crop: image.image ) }
      let(:crop2) { image2.crops.create!(aspect_ratio: aspect_ratio, crop: image2.image ) }

      it "should have the same extension as the image" do
        expect(crop.crop.file.extension).to eq "jpg"
        expect(crop2.crop.file.extension).to eq "png"
      end

      it "should change the crop extension when image changes" do
        image.image =  File.open(image2_path)
        image.save
        expect(crop.reload.crop.file.extension).to eq "png"
        image.crops.each do |cropi|
          expect(cropi.reload.crop.file.extension).to eq "png"
        end
        expect(image.image.file.extension).to eq "png"
      end

      it "should set the properly extension even when try to asign different one to a crop" do
        expect(crop.crop.file.extension).to eq "jpg"

        crop.crop = File.open(image2_path)
        crop.save

        expect(crop.crop.file.extension).to eq "jpg"
      end
    end


    context "regarding the path" do

      it "should be predicatble" do
        expect(URI.unescape(crop.crop.url)).to eq "/uploads/image/#{image.id}/crops/#{aspect_ratio}/image.jpg"
      end

    end
end
