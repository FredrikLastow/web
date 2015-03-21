# encoding:UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :configure_permitted_devise_parameters, if: :devise_controller?
  before_filter :set_locale
  before_filter :get_commit

  rescue_from CanCan::AccessDenied do |ex|
    flash[:error] = ex.message
    render :text => '', :layout => true, :status => :forbidden
  end

  rescue_from ActiveRecord::RecordInvalid do |ex|
    flash[:error] = 
      "Fel i formulär:  #{ex.record.errors.full_messages.join '; '}"
    render referring_action, :status => :unprocessable_entity
  end

  protected
  def configure_permitted_devise_parameters
    devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:username, :password, :remember_me)}
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:username, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:password, :password_confirmation, :current_password) }
  end

  def set_locale
    locale = 'sv'
    langs  = %w{ sv en }

    if params[:locale]
      lang = params[:locale]
      if langs.include? lang
        locale           = lang
        cookies[:locale] = lang
      end
    else
      if cookies[:locale]
        lang   = cookies[:locale]
        locale = lang if langs.include? lang
      end
    end

    I18n.locale = locale
    redirect_to(:back) if params[:locale]
  end

  def get_commit
    if user_signed_in? && current_user.is?(:admin)
      @commit = `git rev-parse HEAD`[0, 6]
      @commit_url = "https://github.com/fsek/web/commit/%s" % @commit
    end
  end

  def referring_action
    Rails.application.routes.recognize_path(request.referer)[:action]
  end
end
