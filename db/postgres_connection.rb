require 'pg'

class PostgresDirect
  def connect
    @conn = PG.connect(
      :dbname => 'd30esgeie7ppvv',
      :host => 'ec2-174-129-41-12.compute-1.amazonaws.com',
      :port => '5432',
      :user => 'jhuhnplxphfwuu',
      :password => 'a025229d75ed85b06fb24da06ed41bdc29e5b9287a61f6bcb15082889b072e1b')
  end
  def execProcedureDB(stringQuery)
    newQuery = "select * from " + stringQuery
    @conn.exec(newQuery) do |result|
      return result.values
    end
  end

  def disconnect
    @conn.close
  end
end