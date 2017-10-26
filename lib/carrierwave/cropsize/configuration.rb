module Carrierwave
  module Cropsize
    include ActiveSupport::Configurable

    config_accessor :storage
    config_accessor :override_filenames

    self.storage = :file
    self.override_filenames = true

  end
end
