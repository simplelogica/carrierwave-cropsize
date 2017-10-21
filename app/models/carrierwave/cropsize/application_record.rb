module Carrierwave
  module Cropsize
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
