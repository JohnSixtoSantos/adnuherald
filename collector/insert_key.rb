require 'pg'

@keywords_set = false
@keywords = ""
@continue = true
@db_host = ""
@db_port = ""
@db_database = ""
@db_username = ""
@db_password = ""
@conn = nil

print "Loading database configuration file..."
    
File.open("configuration", "r").each_line do |line|
        data = line.split(": ")
        
        if data[0] == "host" then
            @db_host = data[1].strip
            elsif data[0] == "database" then
            @db_database = data[1].strip
            elsif data[0] == "username" then
            @db_username = data[1].strip
            elsif data[0] == "password" then
            @db_password = data[1].strip
            elsif data[0] == "port" then
            @db_port = data[1].strip
        end
end

puts 'done!'

print 'About to connect to the database...'

@conn = PGconn.connect(:host=>@db_host, :port=>@db_port, :dbname=>@db_database, :user=>@db_username, :password=>@db_password)

puts 'done!'

print 'Inserting keys...'

File.open("keys", "r").each_line do |line|
    res = @conn.exec("INSERT INTO keyword VALUES ('#{line}');")
end

puts 'done!'
