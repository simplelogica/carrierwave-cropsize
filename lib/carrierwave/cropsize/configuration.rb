module Carrierwave
  module Cropsize
    include ActiveSupport::Configurable

    config_accessor :storage

    self.storage = :file

  end
end
