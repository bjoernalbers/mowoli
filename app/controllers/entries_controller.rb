class EntriesController < ApplicationController
  protect_from_forgery except: [:create]

  def index
    @entries = Entry.all
  end

  def create
    @entry = Entry.new(entry_params)
    if @entry.save
      msg = "Entry successfully created:\n\n"
      msg << @entry.attributes.map { |k,v| "#{k}: #{v}" }.join("\n")
      msg << "\n"
      render text: msg, status: :created
    else
      msg = "Failed to create entry! Errors:\n\n"
      msg << @entry.errors.full_messages.join("\n")
      msg << "\n"
      render text: msg, status: :unprocessable_entity
    end
  end

  private

  def entry_params
    params.require(:entry).
      permit(:accession_number,
             :referring_physicians_name,
             :patients_name,
             :patient_id,
             :patients_birth_date,
             :patients_sex,
             :requesting_physicians_name,
             :requested_procedure_description,
             :modality,
             :scheduled_station_ae_title)
  end
end
