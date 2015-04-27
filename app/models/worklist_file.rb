class WorklistFile
  attr_reader :entry

  def initialize(entry)
    @entry = entry
  end

  # Creates worklist file.
  def create
    File.open(path, 'w') { |f| f.puts content }
  end

  # Deletes worklist file.
  def delete
    FileUtils.rm(path) if created?
  end

  def content
    EntriesController.new.
      render_to_string('show.xml', locals: { entry: entry })
  end

  def path
    File.join(Rails.configuration.worklist_dir,
              entry.study_instance_uid + '.xml')
  end

  private

  def created?
    File.exists?(path)
  end
end
