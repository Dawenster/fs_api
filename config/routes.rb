FsYvrApi::Application.routes.draw do
  resources :flights, :only => [:create]
end
