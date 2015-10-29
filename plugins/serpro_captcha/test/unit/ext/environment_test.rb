# require File.dirname(__FILE__) + '/../../../../../test/test_helper'
#
# class EnvironmentTest < ActiveSupport::TestCase
#
#   def setup
#     @enviroment = Environment.default
#   end
#
#   should 'have serpro_captcha_plugin variable defined' do
#     assert_equal Hash, @enviroment.serpro_captcha_plugin.class
#   end
#
#   should 'return an empty hash by default on serpro_captcha_plugin_attributes method' do
#     assert_equal Hash.new, @enviroment.serpro_captcha_plugin_attributes
#   end
#
#   should 'serpro_captcha_plugin_host= define the ldap host' do
#     host = "http://something"
#     @enviroment.serpro_captcha_plugin_host= host
#     assert_equal host, @enviroment.serpro_captcha_plugin['host']
#   end
#
#   should 'serpro_captcha_plugin_host return the defined ldap host' do
#     host = "http://something"
#     @enviroment.serpro_captcha_plugin_host= host
#     assert_equal host, @enviroment.serpro_captcha_plugin_host
#   end
#
#   should 'serpro_captcha_plugin_port= define the ldap port' do
#     value = 255
#     @enviroment.serpro_captcha_plugin_port= value
#     assert_equal value, @enviroment.serpro_captcha_plugin['port']
#   end
#
#   should 'serpro_captcha_plugin_port return the defined ldap port' do
#     value = 255
#     @enviroment.serpro_captcha_plugin_port= value
#     assert_equal value, @enviroment.serpro_captcha_plugin_port
#   end
#
#   should 'default serpro_captcha_plugin_port be 389' do
#     assert_equal 389, @enviroment.serpro_captcha_plugin_port
#   end
#
#   should 'serpro_captcha_plugin_account= define the ldap acccount' do
#     value = 'uid=sector,ou=Service,ou=corp,dc=company,dc=com,dc=br'
#     @enviroment.serpro_captcha_plugin_account= value
#     assert_equal value, @enviroment.serpro_captcha_plugin['account']
#   end
#
#   should 'serpro_captcha_plugin_account return the defined ldap account' do
#     value = 'uid=sector,ou=Service,ou=corp,dc=company,dc=com,dc=br'
#     @enviroment.serpro_captcha_plugin_account= value
#     assert_equal value, @enviroment.serpro_captcha_plugin_account
#   end
#
#   should 'serpro_captcha_plugin_account_password= define the ldap acccount_password' do
#     value = 'password'
#     @enviroment.serpro_captcha_plugin_account_password= value
#     assert_equal value, @enviroment.serpro_captcha_plugin['account_password']
#   end
#
#   should 'serpro_captcha_plugin_account_password return the defined ldap account password' do
#     value = 'password'
#     @enviroment.serpro_captcha_plugin_account_password= value
#     assert_equal value, @enviroment.serpro_captcha_plugin_account_password
#   end
#
#   should 'serpro_captcha_plugin_base_dn= define the ldap base_dn' do
#     value = 'dc=company,dc=com,dc=br'
#     @enviroment.serpro_captcha_plugin_base_dn= value
#     assert_equal value, @enviroment.serpro_captcha_plugin['base_dn']
#   end
#
#   should 'serpro_captcha_plugin_base_dn return the defined ldap base_dn' do
#     value = 'dc=company,dc=com,dc=br'
#     @enviroment.serpro_captcha_plugin_base_dn= value
#     assert_equal value, @enviroment.serpro_captcha_plugin_base_dn
#   end
#
#   should 'serpro_captcha_plugin_attr_login= define the ldap attr_login' do
#     value = 'uid'
#     @enviroment.serpro_captcha_plugin_attr_login= value
#     assert_equal value, @enviroment.serpro_captcha_plugin['attr_login']
#   end
#
#   should 'serpro_captcha_plugin_attr_login return the defined ldap attr_login' do
#     value = 'uid'
#     @enviroment.serpro_captcha_plugin_attr_login= value
#     assert_equal value, @enviroment.serpro_captcha_plugin_attr_login
#   end
#
#   should 'serpro_captcha_plugin_attr_fullname= define the ldap attr_fullname' do
#     value = 'Noosfero System'
#     @enviroment.serpro_captcha_plugin_attr_fullname= value
#     assert_equal value, @enviroment.serpro_captcha_plugin['attr_fullname']
#   end
#
#   should 'serpro_captcha_plugin_attr_fullname return the defined ldap attr_fullname' do
#     value = 'uid'
#     @enviroment.serpro_captcha_plugin_attr_fullname= value
#     assert_equal value, @enviroment.serpro_captcha_plugin_attr_fullname
#   end
#
#
#   should 'serpro_captcha_plugin_attr_mail= define the ldap attr_mail' do
#     value = 'test@noosfero.com'
#     @enviroment.serpro_captcha_plugin_attr_mail= value
#     assert_equal value, @enviroment.serpro_captcha_plugin['attr_mail']
#   end
#
#   should 'serpro_captcha_plugin_attr_mail return the defined ldap attr_mail' do
#     value = 'test@noosfero.com'
#     @enviroment.serpro_captcha_plugin_attr_mail= value
#     assert_equal value, @enviroment.serpro_captcha_plugin_attr_mail
#   end
#
#   should 'serpro_captcha_plugin_onthefly_register= define the ldap onthefly_register' do
#     value = '1'
#     @enviroment.serpro_captcha_plugin_onthefly_register= value
#     assert @enviroment.serpro_captcha_plugin['onthefly_register']
#   end
#
#   should 'serpro_captcha_plugin_onthefly_register return true if ldap onthefly_register variable is defined as true' do
#     value = '1'
#     @enviroment.serpro_captcha_plugin_onthefly_register= value
#     assert @enviroment.serpro_captcha_plugin_onthefly_register
#   end
#
#   should 'serpro_captcha_plugin_onthefly_register return false if ldap onthefly_register variable is defined as false' do
#     value = '0'
#     @enviroment.serpro_captcha_plugin_onthefly_register= value
#     refute @enviroment.serpro_captcha_plugin_onthefly_register
#   end
#
#   should 'serpro_captcha_plugin_filter= define the ldap filter' do
#     value = 'test'
#     @enviroment.serpro_captcha_plugin_filter= value
#     assert_equal value, @enviroment.serpro_captcha_plugin['filter']
#   end
#
#   should 'serpro_captcha_plugin_filter return the defined ldap filter' do
#     value = 'test'
#     @enviroment.serpro_captcha_plugin_filter= value
#     assert_equal value, @enviroment.serpro_captcha_plugin_filter
#   end
#
#   should 'serpro_captcha_plugin_tls= define the ldap tls' do
#     value = '1'
#     @enviroment.serpro_captcha_plugin_tls= value
#     assert @enviroment.serpro_captcha_plugin['tls']
#   end
#
#   should 'tls return true if ldap tls variable is defined as true' do
#     value = '1'
#     @enviroment.serpro_captcha_plugin_tls= value
#     assert @enviroment.serpro_captcha_plugin_tls
#   end
#
#   should 'tls return false if ldap tls variable is defined as false' do
#     value = '0'
#     @enviroment.serpro_captcha_plugin_tls= value
#     refute @enviroment.serpro_captcha_plugin_tls
#   end
#
#   should 'validates presence of host' do
#     @enviroment.serpro_captcha_plugin= {:port => 3000}
#     @enviroment.valid?
#
#     assert @enviroment.errors.include?(:serpro_captcha_plugin_host)
#
#     @enviroment.serpro_captcha_plugin_host= "http://somehost.com"
#     @enviroment.valid?
#     refute @enviroment.errors.include?(:serpro_captcha_plugin_host)
#   end
#
#   should 'validates presence of host only if some ldap configuration is defined' do
#     @enviroment.valid?
#     refute @enviroment.errors.include?(:serpro_captcha_plugin_host)
#
#     @enviroment.serpro_captcha_plugin= {:port => 3000}
#     @enviroment.valid?
#     assert @enviroment.errors.include?(:serpro_captcha_plugin_host)
#   end
#
# end
