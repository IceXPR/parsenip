class Column < ActiveRecord::Base

  def self.all_keys
    Column.all.collect(&:key).map{|key| key.to_sym}
  end
end
