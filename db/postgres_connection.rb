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
  def execProcedureDB(stringQuery)
    newQuery = "select * from " + stringQuery
    @conn.exec(newQuery) do |result|
      return result.getvalue(0, 0)
    end
  end

  # Disconnect the back-end connection.
  def disconnect
    @conn.close
  end
end

/def verifyFullPath(url)
  p = PostgresDirect.new()
  p.connect
  begin
    p.createUserTable
    #p.prepareInsertUserStatement
    #p.addUser(1, "Marc")
    #p.addUser(2, "Sharon")
    return p.queryUserTable(url) {|row| printf("%d %s\n", row['id'])}
  rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
  ensure
    #p.dropUserTable
    p.disconnect
    #p.disconnect
  end
end/