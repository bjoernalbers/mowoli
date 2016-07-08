class ExportError < StandardError
end

class HL7Export
  FILE_SUFFIX = '.hl7'
  EXPORT_DIR  = Rails.configuration.hl7_export_dir

  attr_reader :order, :dir

  def initialize(order, opts = {})
    @order = order
    @dir   = opts.fetch(:dir) { EXPORT_DIR }
    check_args!
  end

  # Create HL7 file.
  def create
    File.open(path, 'w') { |file| file << content }
  rescue SystemCallError
    raise ExportError
  end

  # Delete HL7 file.
  def delete
    path.delete if path.exist?
  end

  # Return path to HL7 file.
  def path
    @path ||= Pathname.new(dir) + filename
  end

  # Return order as HL7 string.
  def content
    HL7::ORM.new(order).to_hl7
  end

  private

  def filename
    raise ExportError unless order.id
    [order.id, FILE_SUFFIX].join
  end

  def check_args!
    if dir.blank?
      raise ExportError, 'No export directory configured'
    elsif !File.directory?(dir)
      raise ExportError, "\"#{dir}\" is no directory"
    end
  end
end
