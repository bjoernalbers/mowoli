class AddAccessionNumberAndScheduleToOrders < ActiveRecord::Migration
    def change
      add_column :orders, :accession_numberx, :string
      add_column :orders, :scheduled_procedure_step_start_datetime, :string
    end
  end