require 'socket'

socket = TCPSocket.new('0.0.0.0', 8081)

#socket.puts("topic")
#socket.puts("2")
#socket.puts("10")
#socket.puts("10")

socket.puts("summary")
socket.puts("2")
socket.puts("ust")
socket.puts("1")
