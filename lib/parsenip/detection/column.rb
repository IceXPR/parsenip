module Parsenip
  module Detection
    class Column
      attr_accessor :row, :match
      def initialize(row)
        @row = row
        @match = {
            is_first_name: nil,
            is_last_name: nil,
            is_full_name: nil,
            is_phone: nil,
            is_email: nil,
        }
      end
      def split
        @row.split(/,/)
      end
    end
  end
end
