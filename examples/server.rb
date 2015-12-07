#!/usr/bin/env ruby
require "socket"

# @see http://ruby-doc.org/stdlib-2.2.3/libdoc/socket/rdoc/Socket.html#method-c-udp_server_loop
Socket.udp_server_loop(8125) do |msg, msg_src|
  puts "#{Time.now.to_f}: #{msg_src.inspect}: #{msg.inspect}"
end

# exit with Ctrl+C
