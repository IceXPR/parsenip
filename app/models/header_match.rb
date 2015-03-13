class HeaderMatch < ActiveRecord::Base
  def self.has_headers? row
    row.map!(&:downcase)
    matching_count = HeaderMatch.where(value: row).count
    matching_count > (row.count/2)
  end 
end
