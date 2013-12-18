FsApi::Application.routes.draw do
  resources :flights, :only => [:index, :create]
  get "filter" => "flights#filter", :as => :filter
  get "mark-flights-as-old" => "flights#mark_flights_as_old", :as => :mark_flights_as_old
  get "delete-old-flights" => "flights#delete_old_flights", :as => :delete_old_flights
end
