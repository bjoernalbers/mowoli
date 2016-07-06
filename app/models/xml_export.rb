class XMLExport
  attr_reader :order

  def initialize(order)
    @order = order
  end

  # Create XML order.
  def create
    File.open(path, 'w') { |f| f.puts content }
  end

  # Delete XML order.
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
