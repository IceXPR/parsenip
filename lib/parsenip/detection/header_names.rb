
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
        @match
      end

      def all_matched?
        name_matched = (@match[:is_first_name] and @match[:is_last_name]) or @match[:is_full_name]
        name_matched and @match[:is_phone] and @match[:is_email]
      end
      def is_first_name(column)
        column.downcase.match(/first.*name/)
      end
      def is_last_name(column)
        column.downcase.match(/last.*name/)
      end
      def is_phone(column)
        column.downcase.match(/phone.*(number)?/)
      end
      def is_email(column)
        column.downcase.match(/e.?mail/)
      end
    end
  end
end
