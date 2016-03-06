require 'socket'

class ReadRequest
  PORT = 2000
  REQUEST_END = "\r\n"

  def initialize
    @server = TCPServer.new(PORT)
  end

  def call
    socket = @server.accept
    request = []
    loop do
      line = socket.gets
      request << line
      break if line == REQUEST_END
    end
    socket.puts
    socket.close
    puts request
  end
end
