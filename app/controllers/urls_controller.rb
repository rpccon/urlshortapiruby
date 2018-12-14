require 'json'
require "net/http"

require './db/postgres_connection'

class UrlsController < ApplicationController

  def verifyUrlExist(insertedUrl)
    begin
      url = URI.parse(insertedUrl)
      req = Net::HTTP.new(url.host, url.port)
      req.use_ssl = true if url.scheme == 'https'
      res = req.request_head(url.path)
      true
    rescue
      false
    end
  end
  def validateFullPath

    insertedUrl = params.values[0]
    finalUrl = verifyFullPath(insertedUrl)

    if(!finalUrl)
      existUrl = verifyUrlExist(insertedUrl)
      if(existUrl)
        # aplica algoritmos
        @Message = "Apply algorithms"
      else
        @Message = "Url indicated doesn't work, make sure it's correct !"
      end 
    else
      @Message = "The shortest URL is " + finalUrl
      
    end
    # render json: {"url":finalUrl}
    # redirect_to finalUrl
    # @defined = {"a" => "gmail.com/ghgh000"}
  end

  def verifyUrlWeb
    
  end
end
