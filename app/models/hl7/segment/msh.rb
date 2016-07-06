module HL7
  module Segment
    class MSH < Base
      # NOTE: HL7 specifies the "Field Separator" on MSH segment as first field.
      # But actually it is NOT a field, so we don't define it as such.
      field :encoding_characters, default: '^~\&'
      field :sending_application, default: 'Mowoli'
      field :sending_facility
      field :receiving_application
      field :receiving_facility
      field :datetime_of_message, type: DateTime
      field :security
      field :message_type, default: 'ORM^O01^ORM_O01'
      field :message_control_id, default: ->{ SecureRandom.hex(10) }
      field :processing_id
      field :version_id, default: '2.3'
      field :sequence_number
      field :continuation_pointer
      field :accept_acknowledge_type
      field :application_acknowledge_type
      field :country_code
      field :character_set
      field :principal_language_of_message
      field :alternate_character_set_handling_scheme
      field :message_profile_id
    end
  end
end
