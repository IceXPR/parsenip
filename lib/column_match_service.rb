
class ColumnMatchService
  attr_accessor :upload
  attr_accessor :options
  def initialize(upload, options = {})
    @upload = upload
  end

  def detect
    begin
      return detect_by_header_names
    rescue Parsenip::Detection::UnmatchedColumnException => e
      return detect_by_dictionary
    end
  end

  def file
    @upload.file
  end

  def header_row
    File.open(file.path) {|f| f.readline}
  end

  def detect_by_header_names
    Parsenip::Detection::HeaderNames.new(header_row).match
  end

  def detect_by_dictionary
    headers = {}
    Parsenip::Detection::Dictionary.new(@upload).match.each_pair do |key, h|
      headers[key] = h.max_by{|k,v| v}.first
    end
    headers
  end

end

module Parsenip
  module Detection
    class UnmatchedColumnException < Exception
    end
  end
end
