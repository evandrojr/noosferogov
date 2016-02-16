require 'test_helper'

# Controllers to be tested
class CachingTestController < HomeController

end

# Test case
class BlockCacheTest < ActionController::TestCase

  CACHE_DIR = 'block_cache_test'
  FILE_STORE_PATH = Rails.root.join('tmp/test', CACHE_DIR)

  tests CachingTestController

  def setup
    #super

    ActionController::Base.perform_caching = true
    ActionController::Base.page_cache_directory = FILE_STORE_PATH
    ActionController::Base.cache_store = :file_store, FILE_STORE_PATH

    FileUtils.rm_rf(File.dirname(FILE_STORE_PATH))
    FileUtils.mkdir_p(FILE_STORE_PATH)

    @environment = Environment.default
    @environment.enable_plugin('EventPlugin')

    @environment.locales.delete_if {|key, value| key != "en" }

    box = Box.create!(:owner => @environment)
    @block = EventPlugin::EventBlock.create!(:box => box)

    @person  = fast_create(Person, :environment_id => @environment.id)
    @event1 = Event.create!(:name=>'Event 1', :profile =>@person)

  end

  # Event item CSS selector
  ev = '.event-plugin_event-block ul.events li.event[itemscope]' +
       '[itemtype="http://data-vocabulary.org/Event"] '

  def teardown
    FileUtils.rm_rf(File.dirname(FILE_STORE_PATH))
    ActionController::Base.perform_caching = false
  end

  should 'update event block cache' do
    @event1.slug = 'event1a'
    @event1.start_date = DateTime.now
    @event1.end_date = DateTime.now + 3.day
    @event1.save!

    get :index
    entries = Dir.entries(FILE_STORE_PATH)
    # Assert cache dir was created
    assert entries.count == 3

    assert_select ev + 'time.duration[itemprop="endDate"]', /4 days/

    # Change the event
    @event1.reload
    @event1.start_date = DateTime.now
    @event1.end_date = DateTime.now + 5.day
    @event1.save!
    
    get :index

    entries = Dir.entries(FILE_STORE_PATH)

    assert_select ev + 'time.duration[itemprop="endDate"]', /6 days/
  end

end