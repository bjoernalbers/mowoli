class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  @secretpassword=Rails.application.secrets.secret_key_base
  http_basic_authenticate_with name: 'admin', password: @secretpassword

end
