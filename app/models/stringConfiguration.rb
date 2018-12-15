require 'pg'

class StringConfiguration
  $topRecentlyString = "get_top_recently_urls()"
  $serverUrlString = "https://urlshortapiserver.herokuapp.com/redirect/"
  $urlDoesntWork = "Url indicated doesn't work, make sure it's correct !"
  $unknownURL = "Unknown URL"
  $problemDBString = "There was a problem in the database"
  $hashUrlString = "urlshortapiruby"
  $httpsString = "https"
  $resultString = "result"
  $welcomeString = "Welcome to " + $hashUrlString + " API !"

  def updateTitleString(urlTitle, idRegister)
    "update_title('" + urlTitle + "', '" + idRegister.to_s + "')"
  end

  def getTopRecentlyString
    $topRecentlyString
  end

  def validateShortPathString(shortHashUrl)
    "validate_shortPath('" + shortHashUrl + "')"
  end

  def createUpdateVisitedString(shortHashUrl)
    "create_update_visited('" + shortHashUrl + "')"
  end

  def validateFullPathString(insertedUrl)
    "validate_fullpath('" + insertedUrl + "')"
  end

  def getServerUrlString
    $serverUrlString
  end

  def createUrlGetIdString(insertedUrl)
    "create_url_get_id('" + insertedUrl + "')"
  end

  def updateShortPathIdString(newHashUrl, idUrlReg)
    "update_shortpath_from_id('"+ newHashUrl +"', '" + idUrlReg.to_s + "')"
  end

  def getUrlDoesntWorkString
    $urlDoesntWork
  end

  def getUnknownURLString
    $unknownURL
  end

  def getProblemDBString
    $problemDBString
  end

  def getHashUrlString
    $hashUrlString
  end

  def getHttpsString
    $httpsString
  end

  def getResultString
    $resultString
  end

  def getWelcomeString
    $welcomeString
  end
end