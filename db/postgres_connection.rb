/require 'pg'

conn  = PGconn.connect(
    "ec2-174-129-41-12.compute-1.amazonaws.com",
    5432,
    "",
    "",
    "d30esgeie7ppvv",
    "jhuhnplxphfwuu",
    "a025229d75ed85b06fb24da06ed41bdc29e5b9287a61f6bcb15082889b072e1b"
)/

# res = conn.exec("select * from weather")

/res.each {

  city = res[0]['city']
  date = res[0]['date']
  temp_lo = res[0]['temp_lo']
  temp_hi = res[0]['temp_hi']

}/
/def getData()
    res = conn.exec("SELECT * FROM validate_fullpath('aa','','')")
    conn.close
    return res
end/

require 'pg'

class PostgresDirect
  # Create the connection instance.
  def connect
    @conn = PG.connect(
        :dbname => 'd30esgeie7ppvv',
        :host => 'ec2-174-129-41-12.compute-1.amazonaws.com',
        :port => '5432',
        :user => 'jhuhnplxphfwuu',
        :password => 'a025229d75ed85b06fb24da06ed41bdc29e5b9287a61f6bcb15082889b072e1b')
  end

  # Create our test table (assumes it doesn't already exist)
  def createUserTable
    # @conn.exec("CREATEE users (id serial NOT NULL, name character varying(255), CONSTRAINT users_pkey PRIMARY KEY (id)) WITH (OIDS=FALSE);");
  end

  # When we're done, we're going to drop our test table.
  def dropUserTable
    # @conn.exec("DROPE users")
  end

  # Prepared statements prevent SQL injection attacks.  However, for the connection, the prepared statements
  # live and apparently cannot be removed, at least not very easily.  There is apparently a significant
  # performance improvement using prepared statements.
  def prepareInsertUserStatement
    # @conn.prepare("insert_user", "insert into users (id, name) values ($1, $2)")
  end

  # Add a user with the prepared statement.
  def addUser(id, username)
    # @conn.exec_prepared("insert_user", [id, username])
  end

  # Get our data back select * from Url

  def queryUserTable(url)
    newQuery = "select * from validate_fullpath('" + url + "')"
    @conn.exec(newQuery) do |result|
      return result.getvalue(0, 0)
    end
  end

  # Disconnect the back-end connection.
  def disconnect
    @conn.close
  end
end

def verifyFullPath(url)
  p = PostgresDirect.new()
  p.connect
  begin
   # p.createUserTable
    #p.prepareInsertUserStatement
    #p.addUser(1, "Marc")
    #p.addUser(2, "Sharon")
    return p.queryUserTable(url) #{|row| printf("%d %s\n", row['id'])}
  rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
  ensure
    #p.dropUserTable
    p.disconnect
    #p.disconnect
  end
end