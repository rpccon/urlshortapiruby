Rails.application.routes.draw do
  # get '/id/:idName' => 'urls#index' , as: 'idName'

  get '/redirect/:id', to: 'urls#redirectShortPath'
  get '/validateFullPath' => 'urls#validateFullPath'
  get '/top100' => 'urls#topRecently'
end