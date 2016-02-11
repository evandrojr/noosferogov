require File.dirname(__FILE__) + '/../../test_helper'
require File.join(Rails.root, '/lib/noosfero/api/helpers.rb')

class OutcomeCaptcha
  class << self
    attr_accessor :outcome_captcha_test
  end
  @outcome_captcha_test = true
end

module Noosfero
  module API
    module APIHelpers
      def verify_captcha(*args)
        return true if OutcomeCaptcha.outcome_captcha_test
        render_api_error!("Error testing captcha", 403)
      end
    end
  end
end

class ActiveSupport::TestCase

  include Rack::Test::Methods
  include Noosfero::API::APIHelpers

  def app
    Noosfero::API::API
  end

  def login_with_captcha
    json = do_login_captcha_from_api
    @private_token = json["private_token"]
    @params = { "private_token" => @private_token}
    json
  end

  def do_login_captcha_from_api
    post "/api/v1/login-captcha"
    json = JSON.parse(last_response.body)
    json
  end

  def create_article(name)
    @environment = Environment.default
    person = fast_create(Person, :environment_id => @environment.id)
    fast_create(Article, :profile_id => person.id, :name => name)
  end

  def login_api
    @environment = Environment.default
    @user = User.create!(:login => 'testapi', :password => 'testapi', :password_confirmation => 'testapi', :email => 'test@test.org', :environment => @environment)
    @user.activate
    @person = @user.person

    post "/api/v1/login?login=testapi&password=testapi"
    json = JSON.parse(last_response.body)
    @private_token = json["private_token"]
    unless @private_token
      @user.generate_private_token!
      @private_token = @user.private_token
    end

    @params = {:private_token => @private_token}
  end
  attr_accessor :private_token, :user, :person, :params, :environment

  private

  def json_response_ids(kind)
    json = JSON.parse(last_response.body)
    json[kind.to_s].map {|c| c['id']}
  end

end
