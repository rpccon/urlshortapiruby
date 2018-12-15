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

CREATE OR REPLACE FUNCTION validate_shortpath(smallPath VARCHAR)
  RETURNS VARCHAR AS
$BODY$
BEGIN
	RETURN (SELECT fullPath FROM Url WHERE shortPath = smallPath);
END
$BODY$
LANGUAGE plpgsql

CREATE OR REPLACE FUNCTION public.create_url_get_id(allpath character varying)
  RETURNS character varying AS
$BODY$
BEGIN
	INSERT INTO Url(fullPath) VALUES (allPath);
	RETURN (SELECT id FROM Url WHERE fullPath = allPath);
	
EXCEPTION WHEN others THEN
	RETURN 0;
END
$BODY$
  LANGUAGE plpgsql

CREATE OR REPLACE FUNCTION public.update_shortpath_from_id(
    smallpath character varying,
    idregister integer)
  RETURNS integer AS
$BODY$
BEGIN
	UPDATE Url SET shortPath = smallPath WHERE id = idRegister;
	RETURN 1;
EXCEPTION WHEN others THEN
	RETURN 0;
END
$BODY$
  LANGUAGE plpgsql

CREATE OR REPLACE FUNCTION public.update_title(
    titletag character varying,
    idregister integer)
  RETURNS void AS
$BODY$
BEGIN	
	UPDATE Url SET title = titleTag WHERE id = idRegister;
END
$BODY$
  LANGUAGE plpgsql