module HL7
  module Segment
    class Base
      include ActiveAttr::Model

      FIELD_SEPARATOR = '|'

      class << self
        def field_names
          @field_names ||= []
        end

        def field(name, opts = {})
          field_names << name
          attribute name, opts
        end
      end

      def type
        self.class.name ? self.class.name.split('::').last.upcase.first(3) : ''
      end

      def field_names
        self.class.field_names.dup
      end

      def to_hl7
        field_names.inject([ type ]) do |memo,field|
          if self[field] && self[field].is_a?(DateTime)
            memo << self[field].strftime('%Y%m%d%H%M%S')
          else
            memo << self[field]
          end
          memo
        end.join(FIELD_SEPARATOR)
      end
      alias :to_s    :to_hl7

      alias :fields= :attributes=
      alias :fields  :attributes 
    end
  end
end
