Rails.application.routes.draw do
  get '/redirect/:id', to: 'urls#redirectShortPath'
  get '/validateFullPath' => 'urls#validateFullPath'
  get '/top100' => 'urls#topRecently'
  root 'urls#rootRoute'
  match "*path", to: 'urls#noRouteMatch', via: :all
end