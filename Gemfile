source "https://rubygems.org"
gem 'rails',                    '~> 3.2.22'
gem 'minitest',                 '~> 3.2.0'
gem 'fast_gettext',             '~> 0.6.8'
gem 'acts-as-taggable-on',      '~> 3.4.2'
gem 'rails_autolink',           '~> 1.1.5'
gem 'pg',                       '~> 0.13.2'
gem 'rmagick',                  '~> 2.13.1'
gem 'RedCloth',                 '~> 4.2.9'
gem 'will_paginate',            '~> 3.0.3'
gem 'ruby-feedparser',          '~> 0.7'
gem 'daemons',                  '~> 1.1.5'
#gem 'thin',                     '~> 1.3.1'
gem 'nokogiri',                 '~> 1.6.0'
gem 'unicorn',                  '~> 4.8'
#gem 'nokogiri',                 '~> 1.5.5'
gem 'rake', :require => false
gem 'rest-client',              '~> 1.6.7'
gem 'exception_notification',   '~> 4.0.1'
gem 'gettext',                  '~> 2.2.1', :require => false
gem 'locale',                   '~> 2.0.5'
gem 'whenever', :require => false
gem 'eita-jrails', '~> 0.9.5', require: 'jrails'

# API dependencies
gem 'grape',                    '~> 0.12'
gem 'grape-entity'
gem 'grape-swagger'
gem 'swagger-ui_rails'
gem 'kramdown'

#FIXME Get the Grape Loggin from master yo solve this issue https://github.com/intridea/grape/issues/1059
#We have to remove this commit referenve code when update the next release of grape_logging. Actualy we are using (1.1.2)
gem 'grape_logging', :git => 'https://github.com/aceunreal/grape_logging.git', :ref => 'f1755ae'
#gem 'grape_logging'
gem 'rack-cors'
gem 'rack-contrib'
gem 'liquid',                    '~> 3.0.3'
#gem 'grape-swagger-rails'
gem 'rubyzip'

gem 'execjs'
gem 'therubyracer'

# FIXME list here all actual dependencies (i.e. the ones in debian/control),
# with their GEM names (not the Debian package names)

gem 'api-pagination',           '~> 4.1.1'

# asset pipeline
gem 'uglifier', '>= 1.0.3'
gem 'sass-rails'
gem 'sass', '~> 3.1.19'

group :production do
  gem 'dalli', '~> 2.7.0'
end

group :test do
  gem 'rspec',                  '~> 2.14.0'
  gem 'rspec-rails',            '~> 2.14.1'
  gem 'mocha',                  '~> 1.1.0', :require => false
end

group :cucumber do
  gem 'cucumber-rails',         '~> 1.0.6', :require => false
  gem 'capybara',               '~> 2.1.0'
  gem 'cucumber',               '~> 1.0.6'
  gem 'database_cleaner',       '~> 1.2.0'
  gem 'selenium-webdriver',     '~> 2.47.0'
end

# Requires custom dependencies
eval(File.read('config/Gemfile'), binding) rescue nil

# include gemfiles from enabled plugins
# plugins in baseplugins/ are not included on purpose. They should not have any
# dependencies.
Dir.glob('config/plugins/*/Gemfile').each do |gemfile|
  eval File.read(gemfile)
end
