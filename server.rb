require 'socket'

class Server
  PORT = 2000
  OK_RESPONSE = [ "HTTP/1.1 200 OK" ]
  NOT_FOUND_RESPONSE = [ "HTTP/1.1 404 NOT FOUND" ]

  def initialize
    @server = TCPServer.new(PORT)
  end

  def start
    loop { Thread.start(@server.accept) { |socket| handle_request(socket) } }
  end

  private

  def handle_request(socket)
    request_line = socket.gets
    puts request_line

    path = request_line.split[1]
    socket.print(response(path))
    socket.close
  end

  def response(path)
    ((path == "/" ? OK_RESPONSE : NOT_FOUND_RESPONSE) + ["", ""]).join("\r\n")
  end
end
