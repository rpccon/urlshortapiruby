CREATE TABLE Url
(
  id serial PRIMARY KEY,
  shortPath VARCHAR DEFAULT '',
  fullPath VARCHAR,
  title VARCHAR DEFAULT ''
)

CREATE OR REPLACE FUNCTION add_new_url(
    allPath VARCHAR,
    smallPath VARCHAR,
    titleName VARCHAR)
  RETURNS void AS
$BODY$
DECLARE
	finalQuery VARCHAR;
BEGIN
	INSERT INTO Url(shortPath, fullPath, title) VALUES (smallPath, allPath, titleName);
END
$BODY$
  LANGUAGE plpgsql


CREATE OR REPLACE FUNCTION public.validate_fullpath(allpath VARCHAR)
  RETURNS VARCHAR AS
$BODY$
DECLARE
	finalQuery VARCHAR;
BEGIN
	RETURN (SELECT shortPath FROM Url WHERE fullPath = allPath);
END
$BODY$
  LANGUAGE plpgsql 