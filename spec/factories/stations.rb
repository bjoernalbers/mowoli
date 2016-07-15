FactoryGirl.define do
  factory :station do
    name { %w(HAL T-800 T-1000 R2-D2 C-3PO C16 C64 Amiga500 Apple1 Bender Skynet
              WOPR Johnny5 Arduino Thermomix iPod iBookG4 KITT PDP-10).sample }
    aetitle { %w(RED GREEN BLUE).sample + (1..9).to_a.sample.to_s }
    modality
  end
end
