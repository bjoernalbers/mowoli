class WorklistFile
  attr_reader :order

  def initialize(order)
    @order = order
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
    OrdersController.new.
      render_to_string('show.xml', locals: { order: order })
  end

  def path
    File.join(Rails.configuration.worklist_dir,
              "#{order.id}.xml")
  end

  private

  def created?
    File.exists?(path)
  end
end
