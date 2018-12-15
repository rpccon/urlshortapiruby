require 'json'
require "net/http"
require 'hashids'
require 'rss'
require 'httparty'

require './db/postgres_connection'

class UrlsController < ApplicationController
  $problemInDB = "There was a problem in the database"

  def noRouteMatch
    render json: {"result": "No route match"}
  end
  def createHashFromUrl(idNumber)
    hashids = Hashids.new "urlshortapiruby"
    newHashIdentifuer = hashids.encode(idNumber)

    return newHashIdentifuer
  end
  def getTitleTag(insertedUrl)
    bodyUrl = HTTParty.get(insertedUrl).body
    titleUrl = Nokogiri::HTML::Document.parse(bodyUrl).title

    return  titleUrl
  end
  def updateTitleTag(dbInstance, insertedUrl, idRegister)
    urlTitle = getTitleTag(insertedUrl)
    stringUpdateTitle = "update_title('" + urlTitle + "', '" + idRegister.to_s + "')"
    dbInstance.execProcedureDB(stringUpdateTitle)
  end

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
  def redirectShortPath
    mainDBActions = PostgresDirect.new()
    mainDBActions.connect
    shortHashUrl = params[:id]
    # @Message = "No url has been attached"
    stringVerifyShortPath = "validate_shortPath('" + shortHashUrl + "')"
    finalShortUrl = mainDBActions.execProcedureDB(stringVerifyShortPath)

    if(finalShortUrl)
      stringVerifyUpdateCreate = "create_update_visited('" + shortHashUrl + "')"
      resultUptCreate = mainDBActions.execProcedureDB(stringVerifyUpdateCreate)
      if(resultUptCreate)
        redirect_to finalShortUrl
      else
        @Message = $problemInDB
      end
      
      # render json: {"result": finalShortUrl}
    else
      @Message = "Unknown URL"
    end
    # if()
      
    mainDBActions.disconnect
    
  end
  def validateFullPath
    mainDBActions = PostgresDirect.new()
    mainDBActions.connect
    message = ""
    insertedUrl = params.values[0]
    stringVerifyFullPath = "validate_fullpath('" + insertedUrl + "')"
    finalUrl = mainDBActions.execProcedureDB(stringVerifyFullPath)
    serverUrl = "https://urlshortapiserver.herokuapp.com/redirect/"
    if(finalUrl.nil?)
      existUrl = verifyUrlExist(insertedUrl)
      if(existUrl)
        stringCreateGetUrl = "create_url_get_id('" + insertedUrl + "')"
        idUrlReg = Integer(mainDBActions.execProcedureDB(stringCreateGetUrl))

        if(idUrlReg == 0)
          message = $problemInDB
        else
          threadTitle = Thread.new { updateTitleTag(mainDBActions, insertedUrl, idUrlReg) } # updateTitleTag(dbInstance, insertedUrl, titleTag, idRegister)
          threadTitle.join
          newHashUrl = createHashFromUrl(idUrlReg)
          stringUpdateShortUrl = "update_shortpath_from_id('"+ newHashUrl +"', '" + idUrlReg.to_s + "')"
          isHashUpdated = mainDBActions.execProcedureDB(stringUpdateShortUrl)

          if(Integer(isHashUpdated) == 1)
            finalUrlResult = serverUrl + newHashUrl
            message=finalUrlResult
          else
            message = $problemInDB
          end

          # message = "newhash: " + newHashUrl
        end

         #newHashIdentifuer = hashids.encode(1234) # hash
        # aplica algoritmos
        
       # mainCall
        # message = "Apply algorithms"
      else
        message = "Url indicated doesn't work, make sure it's correct !"
      end 
    else
      message = serverUrl + finalUrl
      
    end
      mainDBActions.disconnect
      render json: {"result":message}
    # redirect_to finalUrl
    # @defined = {"a" => "gmail.com/ghgh000"}
  end
end
