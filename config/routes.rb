Rails.application.routes.draw do
  # get '/id/:idName' => 'urls#index' , as: 'idName'

  get '/validateFullPath' => 'urls#validateFullPath'
end