require 'pp'

class Response
  OK_RESPONSE = "HTTP/1.1 200 OK"
  NOT_FOUND_RESPONSE = "HTTP/1.1 404 NOT FOUND"
  LINE_DELIMITER = "\r\n"
  HTML_CONTENT_TYPE = "Content-Type: text/html; charset=utf-8"
  TEXT_CONTENT_TYPE = "Content-Type: text/plain; charset=utf-8"

  def initialize(path)
    @path = path
  end

  def to_s
    [ header, body ].flatten.join(LINE_DELIMITER)
  end

  private

  def header
    [ (valid_path? ? OK_RESPONSE : NOT_FOUND_RESPONSE), content_type, "" ]
  end

  def valid_path?
    path_is_file_or_directory?
  end

  def content_type
    File.file?(local_path) ? TEXT_CONTENT_TYPE : HTML_CONTENT_TYPE
  end

  def local_path
    "www#{@path}"
  end

  def path_is_file_or_directory?
    File.file?(local_path) || File.directory?(local_path)
  end

  def body
    [ (path_is_file_or_directory? ? read_resource : "File not found") ]
  end

  def read_resource
    File.file?(local_path) ? read_file : read_directory
  end

  def read_file
    File.readlines(local_path)
  end

  def read_directory
    [ "<ul>", directory_entry_list_items, "</ul>" ].flatten
  end

  def directory_entry_list_items
    Dir.entries(local_path).map do |entry|
      "<li><a href=\"#{@path}#{entry}\">#{entry}</a></li>"
    end
  end
end
