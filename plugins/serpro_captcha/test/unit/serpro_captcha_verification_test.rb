require 'webmock'
include WebMock::API
require File.dirname(__FILE__) + '/../../../../test/test_helper'
require_relative '../test_helper'

class SerproCaptchaVerificationTest < ActiveSupport::TestCase

  def setup
    @environment = Environment.default
    @environment.enabled_plugins = ['SerproCaptchaPlugin']
    @environment.serpro_captcha_verify_uri="http://www.somecompany.com:443/validate"
    @environment.serpro_captcha_client_id='323232'
    @environment.save!
    @captcha_token = "642646"
    @captcha_text = "44641441"
    @captcha_verification_body = "#{@environment.serpro_captcha_client_id}&#{@captcha_token}&#{@captcha_text}"
  end

  should 'register a user when there are no enabled captcha pluging' do
      @environment.enabled_plugins = []
      @environment.save!
      Environment.default.enable('skip_new_user_email_confirmation')
      params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com" }
      post "/api/v1/register?#{params.to_query}"
      assert_equal 201, last_response.status
      json = JSON.parse(last_response.body)
      assert User['newuserapi'].activated?
      assert json['user']['private_token'].present?
  end

  should 'not register a user if captcha fails' do
      fail_captcha_text @environment.serpro_captcha_verify_uri, @captcha_verification_body
      Environment.default.enable('skip_new_user_email_confirmation')
      params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com", :txtToken_captcha_serpro_gov_br => @captcha_token, :captcha_text => @captcha_text}
      post "/api/v1/register?#{params.to_query}"
      assert_equal 403, last_response.status
      json = JSON.parse(last_response.body)
      assert_equal json["message"],  _("Wrong captcha text, please try again")
  end

  should 'verify_serpro_captcha' do
    pass_captcha @environment.serpro_captcha_verify_uri, @captcha_verification_body
    scv = SerproCaptchaVerification.new
    assert scv.verify_serpro_captcha(@environment.serpro_captcha_client_id, @captcha_token, '44641441', @environment.serpro_captcha_verify_uri)
  end

  should 'fail captcha if user has not filled Serpro\' captcha text' do
    pass_captcha @environment.serpro_captcha_verify_uri, @captcha_verification_body
    scv = SerproCaptchaVerification.new
    hash = scv.verify_serpro_captcha(@environment.serpro_captcha_client_id, @captcha_token, nil, @environment.serpro_captcha_verify_uri)
    assert hash[:user_message], _('Captcha text has not been filled')
  end

  should 'fail captcha if Serpro\' captcha token has not been sent' do
    pass_captcha @environment.serpro_captcha_verify_uri, @captcha_verification_body
    scv = SerproCaptchaVerification.new
    hash = scv.verify_serpro_captcha(@environment.serpro_captcha_client_id, nil, @captcha_text, @environment.serpro_captcha_verify_uri)
    assert hash[:javascript_console_message], _("Missing Serpro's Captcha token")
  end

  should 'fail captcha text' do
    fail_captcha_text @environment.serpro_captcha_verify_uri, @captcha_verification_body
    scv = SerproCaptchaVerification.new
    hash = scv.verify_serpro_captcha(@environment.serpro_captcha_client_id, nil, @captcha_text, @environment.serpro_captcha_verify_uri)
    assert hash[:javascript_console_message], _("Wrong captcha text, please try again")
  end

end
