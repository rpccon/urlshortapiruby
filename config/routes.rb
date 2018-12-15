Rails.application.routes.draw do
  # get '/id/:idName' => 'urls#index' , as: 'idName'

  get '/:id', to: 'urls#redirectShortPath'
  get '/' => 'urls#redirectShortPath'
  get '/validateFullPath' => 'urls#validateFullPath'
end