# README

General information:
-------
    * It is created with Ruby

    * The application is hosted in Heroku.

    * It uses postgreSQL as a database, it is hosted on Heroku too.

    * In the database are created 2 tables, one to manage utl information and the other to store   recently URLs visited.

    * The background-job of the title was created using the Ruby class Thread. Visiting a          procedure in the database to update the shortest url of the already created URL.

    * It includes HTTParty to get tag title of URL.



Endpoints information:
-------

    The domain of the API application is -> https://urlshortapiserver.herokuapp.com


    For test the functionality you can add to the domain:

    * /validateFullPath?url=[here goes the url you want to convert]
    for example https://urlshortapiserver.herokuapp.com/validateFullPath?url=https://www.google.com
    

    * /redirect/[here goes the shortest url you've generated with /validateFullPath for example https://urlshortapiserver.herokuapp.com/redirect/sdfsdf
     

    * /top100 => only adding this text you'll get urls recently used with the title included, with the format [[itemA url, itemA title]]. The link looks like this https://urlshortapiserver.herokuapp.com/top100
    


Shortest URL implementation
-------

First to start work in it, I had to understand how does work tinyUrl. The idea was for each long URL user inserts in the endpoint is important to create an only one identifier and associate it with the long url in the database. First I created an endpoint to receive the url from the user, after that I used "Ruby - Hashids" library to create an specific, unique and small hash id and save it in the database. Before create the hash I created and returned the idNumber of the url in the database, with the idNumber I created the hash and after that I updated to the database by procedure. It is a simple logic, when the user use /redirect/ with the hash generated I go to the database and comeback with the long url to be redirected.


Configuration of the application
-------

    **For install the application in your computer you need to:**

    * Be sure you have Rails installed.

    * Clone the project in one directory.

    * Open the root folder from console.

    * Run in console /bin/bash.

    * Run in console "Bundle install"  -> helps to install packages.

    * Run in console "rails server", to run the application.

    *After that you need to open the browser with the respective port, and use the endpoints explained in the start of the document.

