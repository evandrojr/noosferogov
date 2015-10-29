require 'webmock'
include WebMock::API
require File.dirname(__FILE__) + '/../../../../test/test_helper'
require_relative '../test_helper'

class SerproCaptchaVerificationTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @environment.enabled_plugins = ['SerproCaptchaPlugin']
    @environment.serpro_captcha_verify_uri='https://www.somecompany.com/validate'
    @environment.serpro_captcha_client_id='323232'
    @environment.save!
  end

  should 'register a user when there are no enabled captcha pluging' do
      @environment.enabled_plugins = []
      Environment.default.enable('skip_new_user_email_confirmation')
      params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com" }
      post "/api/v1/register?#{params.to_query}"
      assert_equal 201, last_response.status
      json = JSON.parse(last_response.body)
      assert User['newuserapi'].activated?
      assert json['activated']
      assert json['private_token'].present?
  end

  # should 'not register a user if captcha fails' do
  #     fail_captcha
  #     Environment.default.enable('skip_new_user_email_confirmation')
  #     params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com" }
  #     post "/api/v1/register?#{params.to_query}"
  #     assert_equal 201, last_response.status
  #     json = JSON.parse(last_response.body)
  #     refute User['newuserapi'].activated?
  #     refute !json['activated']
  #     refute !json['private_token'].present?
  # end

  should 'verify_serpro_captcha' do
    pass_captcha
    spv = SerproCaptchaVerification.new
    assert spv.verify_serpro_captcha(@environment.serpro_captcha_client_id, '642646', '44641441', @environment.serpro_captcha_verify_uri)
  end

  should 'fail captcha if user has not filled Serpro\' captcha text' do
    pass_captcha
    spv = SerproCaptchaVerification.new
    hash = spv.verify_serpro_captcha(@environment.serpro_captcha_client_id, '642646', nil, @environment.serpro_captcha_verify_uri)
    assert hash[:user_message], _('Captcha text has not been filled')
  end

  should 'fail captcha if Serpro\' captcha token has not been sent' do
    pass_captcha
    spv = SerproCaptchaVerification.new
    hash = spv.verify_serpro_captcha(@environment.serpro_captcha_client_id, nil, '76876846', @environment.serpro_captcha_verify_uri)
    assert hash[:javascript_console_message], _("Missing Serpro's Captcha token")
  end

end
