# Observation Result
module HL7
  module Segment
    class OBX < Base
      field :set_id
      field :value_type
      field :observation_identifier
      field :observation_sub_id
      field :observation_value
      field :units
      field :references_range
      field :abnormal_flags
      field :probability
      field :nature_of_abnormal_test
      field :observation_result_status
      field :effective_date_of_reference_range, type: DateTime
      field :user_defined_access_checks
      field :datetime_of_the_observation, type: DateTime
      field :producers_id
      field :responsible_observer
      field :observation_method
      field :equipment_instance_identifier
      field :datetime_of_the_analysis, type: DateTime
    end
  end
end
