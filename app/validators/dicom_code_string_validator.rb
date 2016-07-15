class DicomCodeStringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value) 
    if value.present?
      unless value =~ /\A[A-Z0-9_ ]{,16}\z/
        record.errors[attribute] << 'is no valid DICOM Code String'
      end
    end
  end
end
