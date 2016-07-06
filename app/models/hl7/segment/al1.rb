# Allergy Information
module HL7
  module Segment
    class AL1 < Base
      field :event_type_code
      field :allergen_type_code
      field :allergen_code
      field :allergy_severity_code
      field :allergy_reaction_code
      field :identification_date, type: DateTime
    end
  end
end
