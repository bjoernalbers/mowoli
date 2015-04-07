class PersonName
  include ActiveModel::Model

  ATTRIBUTES = %i(family given middle prefix suffix)

  ATTRIBUTES.each { |attr| attr_accessor attr }

  def to_s
    ATTRIBUTES.map { |attr| self.send(attr) }.join('^').gsub(/\^+$/, '')
  end
end
