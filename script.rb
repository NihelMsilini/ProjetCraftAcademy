#!/usr/bin/env ruby
#Needed librairies
require 'rubygems'
require 'json'
# Update the system
system 'echo "updating..."'
system 'apt-get update'
# To read the json parameters file
json = File.read('parameters.json')
# To parse the json file
obj = JSON.parse(json)
# Set parameters to configure
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
# System update
system "apt-get update > /dev/null 2>&1 "
# Installing nginx server
system "apt-get -y  install nginx > /dev/null 2<&1"
# Enable service
puts 'Enable service ...'
system "update-rc.d nginx defaults"
# Start server
system "service nginx restart"
puts 'Starting nginx server...[OK]'
# Installing redis
puts 'Redis server installation...'
system "apt-get -y install -y redis-server > /dev/null 2>&1"
system "service redis-server status"
puts 'Server status...'
# Start server
system "service redis-server restart"
puts 'Server start...[OK]'
