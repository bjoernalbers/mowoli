class PersonName
  include ActiveModel::Model

  ATTRIBUTES = [:family, :given, :middle, :prefix, :suffix]

  def self.attributes
    ATTRIBUTES
  end

  ATTRIBUTES.each { |attr| attr_accessor attr }

  def to_s
    ATTRIBUTES.map { |attr| self.send(attr) }.join('^').gsub(/\^+$/, '')
  end
end
