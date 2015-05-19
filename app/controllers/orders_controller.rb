class OrdersController < ApplicationController
  protect_from_forgery except: [:create]

  def index
    @orders = Order.all
  end

  def create
    @order =
      Order.find_by(accession_number: order_params[:accession_number]) ||
      Order.new(order_params)

    if @order.save
      msg = "Order successfully created:\n\n"
      msg << @order.attributes.map { |k,v| "#{k}: #{v}" }.join("\n")
      msg << "\n"
      render text: msg, status: :created
    else
      msg = "Failed to create order! Errors:\n\n"
      msg << @order.errors.full_messages.join("\n")
      msg << "\n"
      render text: msg, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).
      permit(:accession_number,
             :referring_physicians_name,
             :patients_name,
             :patient_id,
             :patients_birth_date,
             :patients_sex,
             :requesting_physicians_name,
             :requested_procedure_description,
             :station_name)
  end
end
