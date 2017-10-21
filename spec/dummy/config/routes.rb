Rails.application.routes.draw do
  mount Carrierwave::Cropsize::Engine => "/carrierwave-cropsize"
end
