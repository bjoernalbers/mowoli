class Station < ActiveRecord::Base
  MODALITY_CODES = [
    'AU', # Audio 
    'BI', # Biomagnetic imaging 
    'CD', # Color flow Doppler 
    'CR', # Computed Radiography 
    'CT', # Computed Tomography 
    'DD', # Duplex Doppler 
    'DG', # Diaphanography 
    'DX', # Digital Radiography 
    'ECG', # Electrocardiography 
    'EPS', # Cardiac Electrophysiology 
    'ES', # Endoscopy 
    'GM', # General Microscopy 
    'HC', # Hard Copy 
    'HD', # Hemodynamic Waveform 
    'IO', # Intra-oral Radiography 
    'IVUS', # Intravascular Ultrasound 
    'KO', # Key Object Selection 
    'LS', # Laser surface scan 
    'MG', # Mammography 
    'MR', # Magnetic Resonance 
    'NM', # Nuclear Medicine 
    'OCT', # Optical Coherence Tomography 
    'OP', # Ophthalmic Photography 
    'OPM', # Ophthalmic Mapping 
    'OPR', # Ophthalmic Refraction 
    'OPV', # Ophthalmic Visual Field 
    'OT', # Other 
    'PR', # Presentation State 
    'PT', # Positron emission tomography (PET) 
    'PX', # Panoramic X-Ray 
    'REG', # Registration 
    'RF', # Radio Fluoroscopy 
    'RG', # Radiographic imaging (conventional film/screen) 
    'RTDOSE', # Radiotherapy Dose 
    'RTIMAGE', # Radiotherapy Image 
    'RTPLAN', # Radiotherapy Plan 
    'RTRECORD', # RT Treatment Record 
    'RTSTRUCT', # Radiotherapy Structure Set 
    'SEG', # Segmentation 
    'SM', # Slide Microscopy 
    'SMR', # Stereometric Relationship 
    'SR', # SR Document 
    'ST', # Single-photon emission computed tomography (SPECT) 
    'TG', # Thermography 
    'US', # Ultrasound 
    'XA', # X-Ray Angiography 
    'XC', # External-camera Photography 
  ]

  has_many :orders

  validates :name,
    presence: true

  validates :modality,
    presence: true,
    inclusion: { in: MODALITY_CODES }

  validates :aetitle,
    presence: true,
    length: { maximum: 16 },
    format: { with: /\A[a-zA-Z\d\_\.\-]+\Z/ }
end
