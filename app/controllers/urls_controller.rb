require './db/postgres_connection'
require 'json'

class UrlsController < ApplicationController
  def validateFullPath

    url = params.values[0]
    finalUrl = verifyFullPath(url)

    if(!finalUrl)
      render json: {"url":finalUrl}
    else
      redirect_to finalUrl
    end

    # @defined = {"a" => "gmail.com/ghgh000"}
  end

  def verifyUrlWeb
    
  end
end
