class Station < ActiveRecord::Base
  belongs_to :modality, required: true
  has_many :orders, dependent: :destroy

  enum character_set: { 'ISO_IR 100' => 0, 'ISO_IR 192' => 1 }

  validates :name,
    presence: true

  validates :aetitle,
    presence: true,
    length: { maximum: 16 },
    format: { with: /\A[a-zA-Z\d\_\.\-]+\Z/ }
end
