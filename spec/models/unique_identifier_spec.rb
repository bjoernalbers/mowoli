describe UniqueIdentifier do
  let(:uid) { UniqueIdentifier.new }

  describe '#generate' do
    it 'returns unique identifier' do
      expect(uid.generate).not_to eq(uid.generate)
    end

    it 'joins org root prefix with integer UUID suffix' do
      allow(uid).to receive(:org_root).and_return('1.2.3.')
      allow(uid).to receive(:integer_uuid).and_return('4567890')
      expect(uid.generate).to eq('1.2.3.4567890')
    end

    it 'truncates integer UUID after 64 bytes' do
      allow(uid).to receive(:org_root).and_return('1' * 50)
      allow(uid).to receive(:integer_uuid).and_return('2' * 50)
      expect(uid.generate.bytesize).to eq 64
      expect(uid.generate).to match /^\A1{50}2{14}\z/
    end

    it 'ignores integer_uuid with leading zero' do
      allow(uid).to receive(:org_root).and_return('1.2.3.')
      allow(uid).to receive(:integer_uuid).and_return('01', '12')
      expect(uid.generate).to eq('1.2.3.12')
    end
  end

  describe '#org_root' do
    it 'returns default' do
      expect(uid.org_root).to eq '1.2.826.0.1.3680043.9.5265.'
    end
  end

  describe '#integer_uuid' do
    it 'returns unique values' do
      expect(uid.integer_uuid).not_to eq(uid.integer_uuid)
    end

    it 'includes only digits' do
      expect(uid.integer_uuid).to match /\A\d+\z/
    end

    it 'includes at least 32 digits' do
      expect(uid.integer_uuid.bytesize).to be >= 32
    end
  end
end
