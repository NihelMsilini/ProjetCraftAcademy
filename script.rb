#!/usr/bin/env ruby
# Needed librairies
require 'rubygems'
# JSON module installation
system 'gem install json > logs.txt && cat logs.txt'
require 'json'
# Update the system
system 'echo "updating..."'
system 'apt-get -y update >> logs.txt && cat logs.txt'
# To read the json parameters file
json = File.read('parameters.json')
# To parse the json file
obj = JSON.parse(json)
# Set parameters to configure
puts 'config file json parsing'
$hostname= obj['hostname']
$banniere= obj['banniere']
$nameserver= obj['nameserver']
# Display the parameters, just to test
puts 'hostname: '.concat( $hostname.to_s)
puts 'banniere: '.concat( $banniere.to_s)
puts 'nameserver :'.concat ( $nameserver.to_s)
# hostname configuration
hostFile=File.open("/etc/hostname","w+")
hostFile.write($hostname.to_s) 
# banner configuration
banFile=File.open("/etc/motd","w+")
banFile.write($banniere.to_s)
# nameserver configuration
serverFile=File.open("/etc/resolv.conf","a+")
serverFile.write("nameserver ".concat($nameserver.to_s))
# Installing nginx and Redis
puts 'Installing nginx with a ruby script'
# Installing nginx server
system "apt-get -y  install nginx >> logs.txt && cat logs.txt"
# Enable service
puts 'Enable service ...'
system "update-rc.d nginx defaults"
# Start server
system "service nginx restart >> logs.txt && cat logs.txt"
puts 'Starting nginx server...[OK]'
# Installing redis
puts 'Redis server installation...'
system "apt-get -y install -y redis-server >> logs.txt && cat logs.txt"
system "service redis-server status"
puts 'Server status...'
# Start server
system "service redis-server restart >> logs.txt && cat logs.txt"
puts 'Server start...[OK]'
# Installing module redis
system "gem install redis >> logs.txt && cat logs.txt"
system "apt-get install bundler >> logs.txt && cat logs.txt"
require 'redis'
# parse the log file and create a table
fichier = File.open("logs.txt", "r")
i = 1
chaine = ""
fichier.each_line { |ligne|
  chaine=chaine.concat"#{ligne}"
  i += 1
}
fichier.close
# Database connection with host : localhost and port : 6379
redis=Redis.new(:host => 'localhost', :port => 6379)
# Set key log and database insertion
redis.set('log', chaine)
# get the chaine that corresponds to log key
value = redis.get('log');
# Display value
puts value
# Opening a web page
puts 'HTML page generating..'
index=File.open("/usr/share/nginx/html/index.html","w+")
index.write("<!DOCTYPE html>
<html>
<head>
<title>My Nginx Welcome Page!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1><center>This is my welcome page served by Nginx !</center></h1>
<p><center>Generate an HTML page from a ruby script.</center></p>
<p><em><center>Thank you for using nginx !!</center></em></p>
</body>
</html>")
puts ' Run nginx server...'
system "service nginx restart"
puts 'Start server...[OK]'
