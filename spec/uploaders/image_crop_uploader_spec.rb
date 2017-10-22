require 'spec_helper'


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

        let(:crop) { image.crops.create!(aspect_ratio: aspect_ratio, crop: image.image.file ) }

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

        let(:crop) { image.crops.create!(aspect_ratio: aspect_ratio, crop: image.image.file ) }

        context 'creating a horizontal crop' do

          let(:aspect_ratio) { "1600:610" }

          it "should create it with the right dimensions" do
            expect(crop.height).to eq 630
            expect(crop.width).to eq 1652
          end

        end
      end
    end



end
