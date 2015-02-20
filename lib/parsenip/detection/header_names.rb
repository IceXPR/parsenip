
module Parsenip
  module Detection
    class HeaderNames < Parsenip::Detection::Column
      def match
        split.each_with_index do |column, index|

          if is_first_name(column)
            @match[:first_name] = index
          end

          if is_last_name(column)
            @match[:last_name] = index
          end

          if is_phone(column)
            @match[:phone] = index
          end

          if is_email(column)
            @match[:email] = index
          end

        end

        raise Parsenip::Detection::UnmatchedColumnException unless all_matched?
      end

      def all_matched?
        @match.values.all?
      end
      def is_first_name(column)
        column.downcase.match(/first.*name/)
      end
      def is_last_name(column)
        column.downcase.match(/last.*name/)
      end
      def is_phone(column)
        column.downcase.match(/phone.*number/)
      end
      def is_email(column)
        column.downcase.match(/email/)
      end
    end
  end
end
