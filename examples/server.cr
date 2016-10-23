require "socket"

server = UDPSocket.new
server.bind "0.0.0.0", 8125

spawn do
  loop do
    message = Slice(UInt8).new(1432)
    message_size, message_source = server.receive(message)

    # Only pick the bytes from the message slice
    text = message[0, message_size]
    output = (String.new(text)).inspect

    puts "#{Time.now.to_s("%s.%L")}: #{message_source.address}:#{message_source.port} #{output}"
  end
end

puts "Server started. Exit with Ctrl+C"
sleep
