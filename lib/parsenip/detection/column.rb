module Parsenip
  module Detection
    class Column
      attr_accessor :row, :match
      def initialize(row)
        @row = row
        @match = {
            is_first_name: {},
            is_last_name: {},
            is_full_name: {},
            is_phone: {},
            is_email: {},
        }
      end
      def split
        @row.split(/,/)
      end
    end
  end
end
