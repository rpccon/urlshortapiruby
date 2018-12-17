require 'json'
require "net/http"
require 'hashids'
require 'rss'
require 'httparty'

require './app/models/stringConfiguration'
require './db/postgres_connection'

class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token
  $mainDBActions = PostgresDirect.new()
  $stringConfiguration = StringConfiguration.new()
  $cero = 0
  $resultStr = $stringConfiguration.getResultString
  $urlBrake = $stringConfiguration.getUrlDoesntWorkString

  def rootRoute
    render json: $stringConfiguration.getWelcomeString
  end
  
  def noRouteMatch
    render json: $urlBrake
  end

  def createHashFromUrl(idNumber)
    hashids = Hashids.new $stringConfiguration.getHashUrlString
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
    stringUpdateTitle = $stringConfiguration.updateTitleString(urlTitle, idRegister)
    dbInstance.execProcedureDB(stringUpdateTitle)
  end

  def verifyUrlExist(insertedUrl)
    begin
      url = URI.parse(insertedUrl)
      req = Net::HTTP.new(url.host, url.port)
      req.use_ssl = true if url.scheme == $stringConfiguration.getHttpsString
      res = req.request_head(url.path)
      true
    rescue
      false
    end
  end
  
  def topRecently
    stringtopRecently = $stringConfiguration.getTopRecentlyString
    $mainDBActions.connect
    finalTopRecently = $mainDBActions.execProcedureDB(stringtopRecently)
    $mainDBActions.disconnect
    
    render json: finalTopRecently
  end

  def redirectShortPath
    $mainDBActions.connect
    shortHashUrl = params[:id]
    stringVerifyShortPath = $stringConfiguration.validateShortPathString(shortHashUrl)
    finalShortUrl = $mainDBActions.execProcedureDB(stringVerifyShortPath)[$cero][$cero]

    if(finalShortUrl)
      stringVerifyUpdateCreate = $stringConfiguration.createUpdateVisitedString(shortHashUrl)
      resultUptCreate = $mainDBActions.execProcedureDB(stringVerifyUpdateCreate)[$cero][$cero]

      if(resultUptCreate)
        redirect_to finalShortUrl
      else
        @Message = $stringConfiguration.getProblemDBString
      end
    else
      @Message = $stringConfiguration.getUnknownURLString
    end

    $mainDBActions.disconnect
  end

  def validateFullPath
    $mainDBActions.connect
    message = ""
    insertedUrl = JSON.parse(request.body.read)["url"]

    if(insertedUrl.nil?)
      message = $urlBrake
    else
      stringVerifyFullPath = $stringConfiguration.validateFullPathString(insertedUrl)
      finalUrl = $mainDBActions.execProcedureDB(stringVerifyFullPath)[$cero][$cero]
      serverUrl = $stringConfiguration.getServerUrlString
  
      if(finalUrl.nil?)
        existUrl = verifyUrlExist(insertedUrl)
  
        if(existUrl)
          stringCreateGetUrl = $stringConfiguration.createUrlGetIdString(insertedUrl)
          idUrlReg = Integer($mainDBActions.execProcedureDB(stringCreateGetUrl)[$cero][$cero])
          problemInDB = $stringConfiguration.getProblemDBString
          if(idUrlReg == $cero)
            message = problemInDB
          else
            threadTitle = Thread.new { updateTitleTag($mainDBActions, insertedUrl, idUrlReg) }
            threadTitle.join
            newHashUrl = createHashFromUrl(idUrlReg)
            stringUpdateShortUrl = $stringConfiguration.updateShortPathIdString(newHashUrl, idUrlReg.to_s)
            isHashUpdated = $mainDBActions.execProcedureDB(stringUpdateShortUrl)[$cero][$cero]
  
            if(Integer(isHashUpdated) == 1)
              finalUrlResult = serverUrl + newHashUrl
              message=finalUrlResult
            else
              message = problemInDB
            end
          end
        else
          message = $urlBrake
        end 
      else
        message = serverUrl + finalUrl
      end
    end

    $mainDBActions.disconnect

    render json: message
  end
end
