class UniqueIdentifier
  ORG_ROOT        = '1.2.826.0.1.3680043.9.5265.'
  UID_MAX_LENGTH  = 64

  attr_reader :org_root

  def initialize
    @org_root = ORG_ROOT
  end

  # Generate DICOM-conform UID.
  def generate
    random = integer_uuid until random =~ /\A[^0]+/
    (org_root + random).first(UID_MAX_LENGTH)
  end

  def integer_uuid
    SecureRandom.uuid.gsub('-', '').hex.to_s
  end
end
