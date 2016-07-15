describe DicomCodeStringValidator do
  class Subject
    include ActiveModel::Validations

    attr_accessor :value

    validates :value,
      dicom_code_string: true
  end

  let(:subject) { Subject.new }

  it 'does not validate presence' do
    [ '', nil ].each do |value|
      subject.value = value
      expect(subject).to be_valid
    end
  end

  it 'must have 16 chars max' do
    subject.value = 'A'*16
    expect(subject).to be_valid
    subject.value = 'A'*17
    expect(subject).to be_invalid
    expect(subject.errors[:value]).to be_present
  end

  it 'must only include caps, digits, space and underscore' do
    [ 'CT', ' C T ', 'CT1', 'CT_1' ].each do |value|
      subject.value = value
      expect(subject).to be_valid
    end
    [ 'CT.', 'Ct', 'ÜS', "NM\t" ].each do |value|
      subject.value = value
      expect(subject).to be_invalid
      expect(subject.errors[:value]).to be_present
    end
  end
end
