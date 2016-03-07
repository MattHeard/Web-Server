#!/usr/bin/env ruby

require 'pp'
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
    socket.print(response("www" + path))
    socket.close
  end

  def response(path)
    if valid_file?(path)
      (OK_RESPONSE + ["", read(path).join("\n")]).join("\r\n")
    else
      (NOT_FOUND_RESPONSE + ["", "File not found"]).join("\r\n")
    end
  end

  def read(path)
    File.readlines(path)
  end

  def valid_file?(path)
    File.file?(path) && path != "www/"
  end
end

Server.new.start if __FILE__ == $PROGRAM_NAME
