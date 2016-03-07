#!/usr/bin/env ruby

require 'pp'
require 'socket'

require_relative 'response'

class Server
  PORT = 2000

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
    socket.print(Response.new(path))
    socket.close
  end
end

Server.new.start if __FILE__ == $PROGRAM_NAME
