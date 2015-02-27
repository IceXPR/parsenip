
class ColumnMatchService
  attr_accessor :file
  attr_accessor :options
  def initialize(file, options = {})
    @file = file
  end

  def detect
    begin
      return detect_by_header_names
    rescue Parsenip::Detection::UnmatchedColumnException => e
      return detect_by_dictionary
    end
  end

  def header_row
    File.open(file.path) {|f| f.readline}
  end

  def detect_by_header_names
    Parsenip::Detection::HeaderNames.new(header_row).match
  end

  def detect_by_dictionary
    headers = {}
    Parsenip::Detection::Dictionary.new(file).match.each_pair do |key, h|
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
