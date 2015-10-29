# require File.dirname(__FILE__) + '/../../../../test/test_helper'
# require File.dirname(__FILE__) + '/../../controllers/serpro_captcha_plugin_admin_controller'
#
# # Re-raise errors caught by the controller.
# class SerproCaptchaPluginAdminController; def rescue_action(e) raise e end; end
#
# class SerproCaptchaPluginAdminControllerTest < ActionController::TestCase
#
# def setup
#   @environment = Environment.default
#   user_login = create_admin_user(@environment)
#   login_as(user_login)
#   @admin = User[user_login].person
#   @environment.enabled_plugins = ['SerproCaptchaPlugin']
#   @environment.serpro_captcha_plugin_host="http://somehost"
#   @environment.save!
# end
#
# should 'detected error, Name or service not known, for Serpro captcha communication' do
#   environment = Environment.default
#   environment.serpro_captcha_verify_uri = 'http://someserverthatdoesnotexist.mycompanythatdoesnotexist.com/validate'
#   environment.serpro_captcha_client_id = '000000000000'
#   environment.save!
#   params = {:login => "newuserapi", :password => "newuserapi", :password_confirmation => "newuserapi", :email => "newuserapi@email.com",
#             :txtToken_captcha_serpro_gov_br => '4324343', :captcha_text => '4030320'}
#   post "/api/v1/register?#{params.to_query}"
#   message = JSON.parse(last_response.body)['javascript_console_message']
#   assert_equal "Serpro captcha error: getaddrinfo: Name or service not known", message
# end
