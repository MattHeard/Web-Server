require 'socket'

class ReadManyRequests
  PORT = 2000
  REQUEST_END = "\r\n"

  def initialize
    @server = TCPServer.new(PORT)
  end

  def call
    loop do
      Thread.start(@server.accept) do |socket|
        handle_request(socket)
      end
    end
  end

  def handle_request(socket)
    request = []
    line = nil
    until line == REQUEST_END
      line = socket.gets
      request << line
    end
    socket.puts
    socket.close
    puts request
  end
end
