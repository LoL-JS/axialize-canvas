class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  force_ssl if: :ssl_configured?
  before_action :check_signed_request, :set_locale


  def default_url_options(options={})
    { locale: I18n.locale, trailing_slash: true }
  end

  private
  def check_signed_request
    raise "Invalid Secret" unless !ENV['CANVAS_CONSUMER_SECRET'].nil? && ENV['CANVAS_CONSUMER_SECRET'].strip.length > 0
    raise "No Signed Request" if params[:signed_request].nil?
    encodedSig, encodedEnvelope = params[:signed_request].split('.', 2)
    digest = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), ENV['CANVAS_CONSUMER_SECRET'], encodedEnvelope)).strip()
    raise "Invalid Signed Request" unless digest == encodedSig
    @json = Base64.decode64(encodedEnvelope)
    puts @json
  end

  def set_locale
    I18n.locale = params[:locale] || http_accept_language.compatible_language_from(%w(en fr))
  end

  def ssl_configured?
    !Rails.env.development?
  end
end
