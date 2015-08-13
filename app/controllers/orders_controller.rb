class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def index
    @orders = Order.all
  end

  def create
    @order = Order.new(order_params)

    # TODO: Fix this hack!
    @order.patient_id = "MOWOLI-#{SecureRandom.random_number(1_000_000)}"

    if @order.save
      redirect_to @order
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).
      permit(:patients_birth_date,
             :patients_sex,
             :requested_procedure_description,
             :station_id,
             patients_name_attributes:              PersonName.attributes,
             referring_physicians_name_attributes:  PersonName.attributes)
  end
end
