require 'spec_helper'

describe Carrierwave::Cropsize::ImageUploadWorker do

  let(:image) { Carrierwave::Cropsize::Image.create!  }
  let(:image_url) { "https://picsum.photos/480/360" }

  context 'concerning the sidekiq jobs' do

    before do
      if Gem::Version.new(Rails.version) > Gem::Version.new('6.0')
        image.update(async_remote_image_url: image_url)
      else
        image.update_attributes(async_remote_image_url: image_url)
      end
    end

    it 'should create the upload work' do
      expect(Carrierwave::Cropsize::ImageUploadWorker.jobs.size).to eq 1
    end

  end

  context 'concerning the image' do

    before do
      Sidekiq::Testing.inline!
      if Gem::Version.new(Rails.version) > Gem::Version.new('6.0')
        image.update(async_remote_image_url: image_url)
      else
        image.update_attributes(async_remote_image_url: image_url)
      end
    end

    it 'should keep the same sizes' do
      image.reload
      # If this spec fails without any reason (nothing has changed in the way
      # the image is updated) check that the image url is not returning 404
      expect(image.image?).to be true
      expect(::MiniMagick::Image.open(image.image.file.path)[:dimensions]).to eq [480, 360]
    end

  end
end
