module Parsenip
  module Detection
    class Column
      attr_accessor :row, :match
      def initialize(row)
        @row = row
      end
      def split
        @row.split(/,/)
      end
    end
  end
end
