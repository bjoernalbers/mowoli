# Allergy Information
class AL1 < Segment
  field :event_type_code
  field :allergen_type_code
  field :allergen_code
  field :allergy_severity_code
  field :allergy_reaction_code
  field :identification_date, type: DateTime
end
