
module Parsenip
  module Detection
    class HeaderNames < Parsenip::Detection::Column
      def match
        split.each_with_index do |column, index|

          if is_first_name(column)
            @match[:is_first_name] = index
          end

          if is_last_name(column)
            @match[:is_last_name] = index
          end

          if is_phone(column)
            @match[:is_phone] = index
          end

          if is_email(column)
            @match[:is_email] = index
          end

        end

        raise Parsenip::Detection::UnmatchedColumnException unless all_matched?
      end

      def all_matched?
        total_matched = 0
        @match.each_pair do |k, v|
          if @match[k].values.count > 0
            total_matched +=1
          end
        end
        total_matched == @match.length
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
