Rails.application.routes.draw do
  get '/redirect/:id', to: 'urls#redirectShortPath'
  post '/validateFullPath' => 'urls#validateFullPath'
  get '/top100' => 'urls#topRecently'
  root 'urls#rootRoute'
  match "*path", to: 'urls#noRouteMatch', via: :all
end