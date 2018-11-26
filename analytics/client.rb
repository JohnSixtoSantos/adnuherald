require 'socket'

socket = TCPSocket.new('0.0.0.0', 8081)

socket.puts("topic")
socket.puts("5")
socket.puts("10")
socket.puts("10")
socket.puts("DESC")

#socket.puts("summary")
#socket.puts("7")
#socket.puts("drugs")
#socket.puts("1")
