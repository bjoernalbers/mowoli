class Order < ActiveRecord::Base
  PATIENTS_SEX_CODES = [
    'F', # Female
    'M', # Male
    'O'  # Other
  ]

  belongs_to :station

  attr_accessor :scheduled_performing_physicians_name

  after_initialize :set_default_scheduled_performing_physicians_name

  validates :station,
    presence: true

  # DICOM Value Representation: CS (Code String)
  validates :patients_sex,
    presence: true,
    inclusion: { in: PATIENTS_SEX_CODES }

  # DICOM Value Representation: LO (Long String)
  validates :patient_id, :requested_procedure_description,
    presence: true, length: { maximum: 64 }

  # DICOM Value Representation: PN (Person Name)
  validates :patients_name,
    :referring_physicians_name,
    :scheduled_performing_physicians_name,
    presence: true, length: { maximum: 64 }

  # DICOM Value Representation: DA (Date)
  validates :patients_birth_date,
    presence: true

  # DICOM Value Representation: UI (Unique Identifier, UID)
  validates :study_instance_uid,
    uniqueness: true,
    length: { maximum: 64 },
    format: { with: /\A[\d\.]+\Z/ }

  before_validation :set_study_instance_uid

  after_create :create_export
  before_destroy :destroy_export

  def self.purge_expired
    where('created_at < ?', Time.zone.now.beginning_of_day).destroy_all
  end

  delegate :character_set, :modality, to: :station

  def accession_number
    id.to_s
  end

  def scheduled_station_ae_title
    station.aetitle if station
  end

  def patients_name_attributes=(attr)
    self.patients_name = PersonName.new(attr).to_s
  end

  def referring_physicians_name_attributes=(attr)
    self.referring_physicians_name = PersonName.new(attr).to_s
  end

  def issuer_of_patient_id
    @issuer_of_patient_id ||= ENV.fetch('ISSUER_OF_PATIENT_ID', 'MOWOLI')
  end

  private

  def set_study_instance_uid
    self.study_instance_uid =
      UniqueIdentifier.new.generate unless study_instance_uid
  end

  def set_default_scheduled_performing_physicians_name
    self.scheduled_performing_physicians_name =
      ENV['SCHEDULED_PERFORMING_PHYSICIANS_NAME']
  end

  def create_export
    export.create
  end

  def destroy_export
    export.delete
  end

  def export
    @export ||=
      (station.receives_orders_via_hl7? ? HL7Export : XMLExport).new(self)
  end
end
