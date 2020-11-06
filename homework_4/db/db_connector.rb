require 'mysql2'

def create_db_client
    client = Mysql2::Client.new(
        :host => '127.0.0.1',
        :username => 'root',
        :password => 'Intern@l2301',
        :database => 'food_oms_db'
    )
    client
end