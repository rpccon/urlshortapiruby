require './db/postgres_connection'
require 'json'

class UrlsController < ApplicationController
  def validateFullPath
    puts "In index3"
    puts params
    puts params.values[0]
    puts "In index"

    prer = main
    puts prer
    puts "In index2"

    render json: {"url":prer}

    # @defined = {"a" => "gmail.com/ghgh000"}
  end
end
