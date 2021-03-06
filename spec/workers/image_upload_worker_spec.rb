require 'spec_helper'

describe Carrierwave::Cropsize::ImageUploadWorker do

  let(:image) { Carrierwave::Cropsize::Image.create!  }
  let(:image_url) { "http://img.youtube.com/vi/bQvSYT_z4xE/0.jpg" }

  context 'concerning the sidekiq jobs' do

    before do
      image.update_attributes(async_remote_image_url: image_url)
    end

    it 'should create the upload work' do
      expect(Carrierwave::Cropsize::ImageUploadWorker.jobs.size).to eq 1
    end

  end

  context 'concerning the image' do

    before do
      Sidekiq::Testing.inline!
      image.update_attributes(async_remote_image_url: image_url)
    end

    it 'should keep the same sizes' do
      image.reload
      expect(image.image?).to be true
      expect(::MiniMagick::Image.open(image.image.file.path)[:dimensions]).to eq [480, 360]
    end

  end
end
