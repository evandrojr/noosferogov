require File.dirname(__FILE__) + '/test_helper'

class LoginCaptchaTest < ActiveSupport::TestCase

  def setup()
    @url = "/api/v1/login-captcha"
    OutcomeCaptcha.outcome_captcha_test = true
  end

  should 'not perform a vote without authentication' do
    article = create_article('Article 1')
    params = {}
    params[:value] = 1

    post "/api/v1/articles/#{article.id}/vote?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 401, last_response.status
  end

  should 'perform login from helpers' do
    login_with_captcha
    assert_not_nil @private_token
  end

  should 'perform a vote in an article identified by id' do
    login_with_captcha
    article = create_article('Article 1')
    params[:value] = 1

    post "/api/v1/articles/#{article.id}/vote?#{params.to_query}"
    json = JSON.parse(last_response.body)

    assert_not_equal 401, last_response.status
    assert_equal true, json['vote']
  end

  should 'not perform a vote twice in same article' do
    login_with_captcha
    article = create_article('Article 1')
    params[:value] = 1

    ## Perform a vote twice in API should compute only one vote
    post "/api/v1/articles/#{article.id}/vote?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal true, json['vote']

    post "/api/v1/articles/#{article.id}/vote?#{params.to_query}"
    json = JSON.parse(last_response.body)
    ## Should not allow vote again
    assert_equal false, json['vote']

    total = article.votes_total

    assert_equal 1, total
  end

  should 'not follow any article' do
    login_with_captcha
    article = create_article('Article 1')
    post "/api/v1/articles/#{article.id}/follow?#{params.to_query}"
    json = JSON.parse(last_response.body)

    assert_equal 401, last_response.status
  end

  should 'not generate private token when login without captcha' do
    OutcomeCaptcha.outcome_captcha_test = false
    params = {}
    post "#{@url}#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal last_response.status, 403
    assert json["private_token"].blank?
  end

  should 'generate private token when login with captcha' do
    json = login_with_captcha
    ret = json["private_token"]
    assert !ret.blank?
    assert ret == @private_token
  end

  should 'do login captcha from api' do
    do_login_captcha_from_api
  end

end
