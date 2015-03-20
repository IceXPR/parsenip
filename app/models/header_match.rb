class HeaderMatch < ActiveRecord::Base
  def self.has_headers? row
    row.map!(&:downcase)
    return count_matching_headers(row) > (row.count/2)
  end 

  private
  
  def self.count_matching_headers row
    matches = 0
    row.each do |header|
      matches += 1 if found_header_value?(header)
    end
    return matches
  end

  def self.found_header_value? column 
    HeaderMatch.all.each do |matching_value|
      return true if does_match_value?(matching_value, column)
    end
    return false 
  end

  def self.does_match_value? matching_value, column
    if (column.to_s.include?(matching_value.value))
      found = true 
    end
  end
end
