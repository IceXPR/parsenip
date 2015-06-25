
class ColumnMatchService
  attr_accessor :upload
  attr_accessor :options
  def initialize(upload, options = {})
    @upload = upload
  end

  def detect(number_of_lines)
    detect_by_dictionary(number_of_lines)
  end

  def file
    @upload.file
  end

  def header_row
    File.open(file.path) {|f| f.readline}
  end

  def detect_by_dictionary(number_of_lines)
    headers = {}
    Parsenip::Detection::Dictionary.new(@upload, {number_of_lines: number_of_lines}).match.each_pair do |key, h|
      headers[key] = h.max_by{|k,v| v}.first
    end
    if headers[:first_name] and headers[:last_name]
      if headers[:full_name] and headers[:full_name] > headers[:first_name]
        headers.delete :first_name
        headers.delete :last_name
      else
        headers.delete :full_name
      end
    elsif headers[:full_name]
      headers.delete :first_name
      headers.delete :last_name
    end

    numerical_headers = {}
    @upload.numerical_headers.map do |column|
      numerical_headers[column] = headers.key(column.to_i)
    end
    numerical_headers
  end

end

module Parsenip
  module Detection
    class UnmatchedColumnException < Exception
    end
  end
end
