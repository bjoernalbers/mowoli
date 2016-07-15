class Modality < ActiveRecord::Base
  validates :name,
    presence: true,
    uniqueness: true,
    dicom_code_string: true
  validates :description,
    presence: true

  def to_s
    name
  end
end
