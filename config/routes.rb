FsYyzApi::Application.routes.draw do
  resources :flights, :only => [:index, :create]
  get "filter" => "flights#filter", :as => :filter
end
