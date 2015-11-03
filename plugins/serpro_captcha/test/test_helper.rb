require "#{Rails.root}/lib/noosfero/api/helpers"

class ActiveSupport::TestCase

  include Rack::Test::Methods

  def app
    Noosfero::API::API
  end

  def pass_captcha(mocked_url, captcha_verification_body)
    stub_request(:post, mocked_url).
      with(:body => captcha_verification_body,
           :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "1", :headers => {'Content-Length' => 1})
  end

  def fail_captcha_text(mocked_url, captcha_verification_body)
    stub_request(:post, mocked_url).
      with(:body => captcha_verification_body,
           :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "0", :headers => {'Content-Length' => 1})
  end

  def login_with_captcha
    json = do_login_captcha_from_api
    @private_token = json["private_token"]
    @params = { "private_token" => @private_token}
    json
  end

  ## Performs a login using the session.rb but mocking the
  ## real HTTP request to validate the captcha.
  def do_login_captcha_from_api
    # Request mocking
    #Net::HTTP::Post Mock
    request = mock
    #Net::HTTP Mock
    http = mock
    uri = URI(environment.api_captcha_settings[:verify_uri])
    Net::HTTP.expects(:new).with(uri.host, uri.port).returns(http)
    Net::HTTP::Post.expects(:new).with(uri.path).returns(request)

    # Captcha required codes
    request.stubs(:body=).with("0000000000000000&4324343&4030320")
    http.stubs(:request).with(request).returns(http)

    # Captcha validation success !!
    http.stubs(:body).returns("1")

    params = {:txtToken_captcha_serpro_gov_br => '4324343', :captcha_text => '4030320'}
    post "#{@url}#{params.to_query}"
    json = JSON.parse(last_response.body)
    json
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
