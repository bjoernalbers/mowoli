class Entry < ActiveRecord::Base
  PATIENTS_SEX_CODES = [
    'F', # Female
    'M', # Male
    'O'  # Other
  ]

  # DICOM Value Representation: CS (Code String)
  validates :modality,
    presence: true, length: { maximum: 16 }, format: { with: /\A[A-Z\d\_]+\Z/ }

  # DICOM Value Representation: CS (Code String)
  validates :patients_sex,
    presence: true,
    inclusion: { in: PATIENTS_SEX_CODES }

  # DICOM Value Representation: SH (Short String)
  validates :accession_number,
    presence: true, length: { maximum: 16 }

  # DICOM Value Representation: LO (Long String)
  validates :patient_id, :requested_procedure_description,
    presence: true, length: { maximum: 64 }

  # DICOM Value Representation: PN (Person Name)
  validates :referring_physicians_name, :patients_name, :requesting_physicians_name,
    presence: true, length: { maximum: 64 }

  # DICOM Value Representation: DA (Date)
  validates :patients_birth_date,
    presence: true

  # DICOM Value Representation: AE (Application Entity)
  validates :scheduled_station_ae_title,
    presence: true, length: { maximum: 16 }

  # DICOM Value Representation: UI (Unique Identifier, UID)
  validates :study_instance_uid,
    uniqueness: true,
    length: { maximum: 64 },
    format: { with: /\A[\d\.]+\Z/ }

  before_validation :strip_whitespaces

  before_validation :set_study_instance_uid

  def patients_name_attributes=(attr)
    self.patients_name = PersonName.new(attr).to_s
  end

  def referring_physicians_name_attributes=(attr)
    self.referring_physicians_name = PersonName.new(attr).to_s
  end

  def requesting_physicians_name_attributes=(attr)
    self.requesting_physicians_name = PersonName.new(attr).to_s
  end

  private

  def strip_whitespaces
    self.accession_number =
      accession_number.strip if accession_number.present?
  end

  def set_study_instance_uid
    self.study_instance_uid =
      UniqueIdentifier.new.generate unless study_instance_uid
  end
end
