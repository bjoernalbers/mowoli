require 'rails_helper'

describe 'rendering order template' do
  def render_template_with(order)
    render template: 'orders/show.xml.erb', locals: { order: order }
  end

  it 'includes "Specific Character Set"' do
    order = build(:order)
    allow(order).to receive(:character_set) { 'ISO_IR 42' }
    render_template_with(order)
    expect(rendered).to include '<attr tag="00080005" vr="CS">ISO_IR 42</attr>'
  end

  it 'includes id as "Accession Number"' do
    render_template_with(build(:order, id: '123'))
    expect(rendered).to include '<attr tag="00080050" vr="SH">123</attr>'
  end

  it 'includes "Referring Physicians Name"' do
    render_template_with(build(:order, referring_physicians_name: 'House^Dr.'))
    expect(rendered).to include '<attr tag="00080090" vr="PN">House^Dr.</attr>'
  end

  it 'includes "Referenced Study Sequence"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00081110" vr="SQ"/>'
  end

  it 'includes "Referenced Patient Sequence"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00081120" vr="SQ"/>'
  end

  it 'includes "Patients Name"' do
    render_template_with(build(:order, patients_name: 'Simpson^Homer'))
    expect(rendered).to include '<attr tag="00100010" vr="PN">Simpson^Homer</attr>'
  end

  it 'includes "Patient ID"' do
    render_template_with(build(:order, patient_id: '42'))
    expect(rendered).to include '<attr tag="00100020" vr="LO">42</attr>'
  end

  it 'includes "Issuer of Patient ID"' do
    order = build(:order)
    allow(order).to receive(:issuer_of_patient_id) { 'Chunky Bacon' }
    render_template_with(order)
    expect(rendered).to include '<attr tag="00100021" vr="LO">Chunky Bacon</attr>'
  end

  it 'includes "Patients Birth Date"' do
    render_template_with(build(:order, patients_birth_date: '1978-05-26'))
    expect(rendered).to include '<attr tag="00100030" vr="DA">19780526</attr>'
  end

  it 'includes "Patients Sex"' do
    render_template_with(build(:order, patients_sex: 'M'))
    expect(rendered).to include '<attr tag="00100040" vr="CS">M</attr>'
  end

  it 'includes "Patients Weight"' do
    render_template_with(build(:order, patients_sex: 'M'))
    expect(rendered).to include '<attr tag="00100040" vr="CS">M</attr>'
  end

  it 'includes "Patients Weight"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00101030" vr="DS"/>'
  end

  it 'includes "Medical Alerts"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00102000" vr="LO"/>'
  end

  it 'includes "Contrast Allergies"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00102110" vr="LO"/>'
  end

  it 'includes "Pregnancy Status"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="001021C0" vr="US"/>'
  end

  it 'includes "Study Instance UID"' do
    render_template_with(build(:order, study_instance_uid: '1.2.34.567'))
    expect(rendered).to include '<attr tag="0020000D" vr="UI">1.2.34.567</attr>'
  end

  it 'includes referring physicians name as "Requesting Physicians Name"' do
    render_template_with(build(:order, referring_physicians_name: 'Simpson^Homer'))
    expect(rendered).to include '<attr tag="00321032" vr="PN">Simpson^Homer</attr>'
  end

  it 'includes "Requested Procedure Description"' do
    render_template_with(build(:order, requested_procedure_description: 'brain'))
    expect(rendered).to include '<attr tag="00321060" vr="LO">brain</attr>'
  end

  it 'includes "Requested Procedure Code Sequence"' do
    render_template_with(build(:order, requested_procedure_description: 'brain'))
    expect(rendered).to include '
  <attr tag="00321064" vr="SQ">
    <item>
      <!--Code Value-->
      <attr tag="00080100" vr="SH">brain</attr>
      <!--Coding Scheme Designator-->
      <attr tag="00080102" vr="SH">ConVis</attr>
      <!--Code Meaning-->
      <attr tag="00080104" vr="LO">no meaning</attr>
    </item>
  </attr>'
  end

  it 'includes "Admission ID"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00380010" vr="LO"/>'
  end

  it 'includes "Special Needs"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00380050" vr="LO"/>'
  end

  it 'includes "Current Patient Location"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00380300" vr="LO"/>'
  end

  it 'includes "Patient State"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00380500" vr="LO"/>'
  end

  it 'includes "Modality"' do
    order = build(:order)
    allow(order).to receive(:modality) { 'CT' }
    render_template_with(order)
    expect(rendered).to include '<attr tag="00080060" vr="CS">CT</attr>'
  end

  it 'includes "Requested Contrast Agent"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00321070" vr="LO"/>'
  end

  it 'includes "Scheduled Station AE Title"' do
    station = create(:station, aetitle: 'CHUNKY_BACON')
    render_template_with(build(:order, station: station))
    expect(rendered).to include '<attr tag="00400001" vr="AE">CHUNKY_BACON</attr>'
  end

  it 'includes "Scheduled Procedure Step Start Date"' do
    render_template_with(create(:order, created_at: '1978-05-26 12:34:56'))
    expect(rendered).to include '<attr tag="00400002" vr="DA">19780526</attr>'
  end

  it 'includes "Scheduled Procedure Step Start Time"' do
    render_template_with(create(:order, created_at: '1978-05-26 12:34:56'))
    expect(rendered).to include '<attr tag="00400003" vr="TM">123456</attr>'
  end

  it 'includes "Scheduled Performing Physicians Name"' do
    # Back up environment
    @scheduled_performing_physicians_name =
      ENV['SCHEDULED_PERFORMING_PHYSICIANS_NAME']

    # Change environment
    ENV['SCHEDULED_PERFORMING_PHYSICIANS_NAME'] = 'Chunky Bacon'

    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00400006" vr="PN">Chunky Bacon</attr>'

    # Restore environment
    ENV['SCHEDULED_PERFORMING_PHYSICIANS_NAME'] =
      @scheduled_performing_physicians_name
  end

  it 'includes "Scheduled Procedure Step Description"' do
    render_template_with(build(:order, requested_procedure_description: 'knee'))
    expect(rendered).to include '<attr tag="00400007" vr="LO">knee</attr>'
  end

  it 'includes "Scheduled Protocol Code Sequence"' do
    render_template_with(build(:order, requested_procedure_description: 'knee'))
    expect(rendered).to include '
      <attr tag="00400008" vr="SQ">
        <item>
          <!--Code Value-->
          <attr tag="00080100" vr="SH">knee</attr>
          <!--Coding Scheme Designator-->
          <attr tag="00080102" vr="SH">ConVis</attr>
          <!--Code Meaning-->
          <attr tag="00080104" vr="LO">no meaning</attr>
        </item>
      </attr>'
  end

  it 'includes id as "Scheduled Procedure Step ID"' do
    render_template_with(build(:order, id: '123'))
    expect(rendered).to include '<attr tag="00400009" vr="SH">123</attr>'
  end

  it 'includes "Scheduled Station Name"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00400010" vr="SH"/>'
  end

  it 'includes "Scheduled Procedure Step Location"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00400011" vr="SH"/>'
  end

  it 'includes "Pre-Medication"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00400012" vr="LO"/>'
  end

  it 'includes "Scheduled Procedure Step Status"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00400020" vr="CS"/>'
  end

  it 'includes id as "Requested Procedure ID"' do
    render_template_with(build(:order, id: '123'))
    expect(rendered).to include '<attr tag="00401001" vr="SH">123</attr>'
  end

  it 'includes "Requested Procedure Priority"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00401003" vr="SH"/>'
  end

  it 'includes "Patient Transport Arrangements"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00401004" vr="LO"/>'
  end

  it 'includes "Confidentiality constraint on patient data"' do
    render_template_with(build(:order))
    expect(rendered).to include '<attr tag="00403001" vr="LO"/>'
  end
end
