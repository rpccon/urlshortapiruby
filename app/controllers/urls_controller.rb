require 'json'
require "net/http"
require 'hashids'
require 'rss'
require 'httparty'

require './db/postgres_connection'

class UrlsController < ApplicationController

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
  def validateFullPath
    mainDBActions = PostgresDirect.new()
    mainDBActions.connect
    problemInDB = "There was a problem in the database"
    message = ""
    puts 'looking domain'
    puts params
    insertedUrl = params.values[0]
    stringVerifyFullPath = "validate_fullpath('" + insertedUrl + "')"
    finalUrl = mainDBActions.execProcedureDB(stringVerifyFullPath)

    if(finalUrl.nil?)
      existUrl = verifyUrlExist(insertedUrl)
      if(existUrl)
        stringCreateGetUrl = "create_url_get_id('" + insertedUrl + "')"
        idUrlReg = Integer(mainDBActions.execProcedureDB(stringCreateGetUrl))
        puts 'returnidurl'
        puts idUrlReg
        if(idUrlReg == 0)
          message = problemInDB
        else
          threadTitle = Thread.new { updateTitleTag(mainDBActions, insertedUrl, idUrlReg) } # updateTitleTag(dbInstance, insertedUrl, titleTag, idRegister)
          threadTitle.join
          newHashUrl = createHashFromUrl(idUrlReg)
          stringUpdateShortUrl = "update_shortpath_from_id('"+ newHashUrl +"', '" + idUrlReg.to_s + "')"
          isHashUpdated = mainDBActions.execProcedureDB(stringUpdateShortUrl)

          if(Integer(isHashUpdated) == 1)
            message="updated"
          else
            message = problemInDB
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
      message = "The shortest URL is " + finalUrl
      
    end
      render json: {"result":message}
    # redirect_to finalUrl
    # @defined = {"a" => "gmail.com/ghgh000"}
  end
end
