module API
  module V1
    class OrdersController < BaseController
      before_action :authenticate_request
      def show
        if @order = Order.find_by(id: params[:id])
          # render show template
        else
          head :not_found
        end
      end

      def create
        @order = Order.new(order_params)
        if @order.save
          render :show, status: :created, location: api_v1_order_url(@order)
        else
          render json: { errors: @order.errors.full_messages },
            status: :unprocessable_entity
        end
      end

      def update
        @order = Order.find_by(id: params[:id])
        if @order.update(order_params)
          render :show, station: :success
        else
          render json: { errors: @order.errors.full_messages },
            status: :unprocessable_entity
        end
      end

      def destroy
        if @order = Order.find_by(id: params[:id])
          @order.destroy
          head :no_content
        else
          head :not_found
        end
      end

      private
      def authenticate_request
        @current_key = request.headers["token"]
        @secret =Rails.application.secrets.secret_key_base
        # @current_key = AuthorizeApiRequest.call(request.headers).result
        if @current_key !=@secret
        render json: { error: 'Not Authorized' }, status: 401
        end
        # render json: { error: 'Not Authorized ' }, status: 401 unless @current_user
      end

      def order_params
        p = params.require(:order).
          permit(:accession_numberx,   # work around for accession_number tied to id
                 :scheduled_procedure_step_start_datetime,  # added as extra parameter for butterfly
                :requesting_physicians_name,# added as extra parameter for butterfly
                :study_instance_uid, # added provided study_instance_uid handling
                :patient_id,
                 :patients_birth_date,
                 :patients_sex,
                 :requested_procedure_description,
                 :station_id,
                 patients_name_attributes:              PersonName.attributes,
                 referring_physicians_name_attributes:  PersonName.attributes)
        # TODO: Remove when Tomedo gets a fix!
        coder = HTMLEntities.new
        [ :patients_name_attributes,
          :referring_physicians_name_attributes ].each do |name|
          if p[name]
            p[name].each_pair do |k,v|
              p[name][k] = coder.decode(v) if v.present?
            end
          end
        end
        p
      end
    end
  end
end
