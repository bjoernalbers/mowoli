module HL7
  class ORM
    attr_reader :order

    def initialize(order)
      @order = order
    end

    def msh
      @msh ||= Segment::MSH.new(
        #sending_application:
        #encoding_characters:
        sending_facility: 'Radiologische Gemeinschaftspraxis im Evangelischen Krankenhaus Lippstadt',
        receiving_application: 'Cloverleaf',
        receiving_facility: 'EVK Lippstadt',
        datetime_of_message: Time.zone.now,
        #security:
        #message_type:
        #message_control_id:
        #processing_id:
        #version_id:
        #sequence_number:
        #continuation_pointer:
        #accept_acknowledge_type:
        #application_acknowledge_type:
        #country_code:
        #character_set:
        #principal_language_of_message:
        #alternate_character_set_handling_scheme:
        #message_profile_id:
      )
    end

    def pid
      @pid ||= Segment::PID.new(
        #set_id
        #external_patient_id
        internal_patient_id: order.patient_id,
        #alternate_patient_id
        patient_name: order.patients_name,
        #mothers_maiden_name
        date_of_birth: order.patients_birth_date.to_datetime,
        sex: order.patients_sex,
        #patient_alias
        #race
        #patient_address
        #country_code
        #phone_number_home
        #phone_number_business
        #language
        #marital_status
        #religion
        #patient_account_number
        #social_security_number
        #drivers_license_number
        #mothers_identifier
        #ethnic_group
        #birth_place
        #multiple_birth_indicator
        #birth_order
        #citizenship
        #veterans_military_status
        #nationality
        #patients_death_datetime
        #patients_death_indicator
        #identity_unknown_indicator
        #identity_reliability_code
        #last_update_datetime
        #last_update_facility
        #species_code
        #breed_code
        #strain
        #production_class_code
        #tribal_citizenship
      )
    end

    def pv1
      @pv1 ||= Segment::PV1.new(
        #set_id
        patient_class: 'U', # Patientenstatus / Abrechungsart ist Unbekannt (abk. 'U')
        #assigned_patient_location
        #admission_type
        #preadmit_number
        #prior_patient_location
        #attending_doctor
        referring_doctor: order.referring_physicians_name,
        #consulting_doctor
        #hospital_service
        #temporary_location
        #preadmit_test_indicator
        #readmission_indicator
        #admin_source
        #ambulatory_status
        #vip_indicator
        #admitting_doctor
        #patient_type
        #visit_number
        #financial_class
        #charge_price_indicator
        #courtesy_code
        #credit_rating
        #contract_code
        #contract_effective_date
        #contract_amount
        #contract_period
        #interest_code
        #transfer_to_bad_dept_code
        #transfer_to_bad_dept_date
        #bad_dept_agency_code
        #bad_dept_transfer_amount
        #bad_dept_recovery_amount
        #delete_account_indicator
        #delete_account_date
        #discharge_position
        #discharged_to_location
        #diet_type
        #servicing_facility
        #bed_status
        #account_status
        #pending_location
        #prior_temporary_location
        #admit_datetime
        #discharge_datetime
        #current_patient_balance
        #total_charges
        #total_adjustments
        #total_payments
        #alternate_visit_id
        #visit_indicator
        #other_healthcare_provider
      )
    end

    def al1
      @al1 ||= Segment::AL1.new(
        #event_type_code
        #allergen_type_code
        #allergen_code
        #allergy_severity_code
        #allergy_reaction_code
        #identification_date
      )
    end

    def orc
      @orc ||= Segment::ORC.new(
        order_control: 'NW', # NW == 'New order/service' (http://phinvads.cdc.gov/vads/ViewCodeSystem.action?id=2.16.840.1.113883.12.119)
        placer_order_number: order.accession_number,
        filler_order_number: '^^' + order.study_instance_uid,
        #placer_group_number
        #order_status
        #response_flag
        #quantity_timing
        #parent
        datetime_of_transaction: order.created_at,
        #entered_by
        #verified_by
        #ordering_provider
        #enterers_location
        #call_back_phone_number
        #order_effective_datetime
        #order_control_code_reason
        #entering_organisation
        #entering_device
        #action_by
        #advanced_beneficiary_notice_code
        #ordering_facility_name
        #ordering_facility_address
        #ordering_facility_phone_number
        #ordering_provider_address
        #order_status_modifier
        #advanced_beneficiary_notice_override_reason
        #fillers_expected_availability_datetime
        #confidentiality_code
        #order_type
        #enterer_authorization_mode
      )
    end

    def obr
      @obr ||= Segment::OBR.new(
        #set_id
        #placer_order_number:
        #filler_order_number:
        #universal_service_identifier
        #priority
        #requested_datetime
        #observation_datetime
        #observation_end_datetime
        #collection_volume
        #collection_identifier
        #specimen_action_code
        #danger_code
        #relevant_clinical_information
        #specimen_received_datetime
        #specimen_source
        #ordering_provider
        #order_callback_phone_number
        placer_field_1: order.accession_number,
        #placer_field_2
        #filler_field_1
        #filler_field_2
        #result_status_change_datetime
        #charge_to_practice
        diagnostic_serv_sect_id: order.scheduled_station_ae_title,
        #result_status
        #parent_result
        #quantity_timing
        #result_copies_to
        #parent
        #transportation_mode
        #reason_for_study
        #principal_result_interpreter
        #assistant_result_interpreter
        technician: order.scheduled_performing_physicians_name,
        #transcriptionist
        #scheduled_datetime
        #number_of_sample_containers
        #transport_logistics_of_collected_sample
        #collectors_comment
        #transport_arrangement_responsibility
        #transport_arranged
        #escort_required
        #planned_patient_transport_comment
        procedure_code: '^^^^' + order.requested_procedure_description,
        #procedure_code_modifier
        #placer_supplemental_service_information
        #filler_supplemental_service_information
        #medical_necessary_duplicate_procedure_reason
        #result_handling
      )
    end

    def to_hl7
      [ msh, pid, pv1, orc, obr ].map(&:to_hl7).join("\r")
    end
  end
end
