require File.dirname(__FILE__) + '/../test_helper'
class VideoPluginTest < ActiveSupport::TestCase

  def self.owner_video_galleries(owner)
    conditions = owner.kind_of?(Environment) ?  [] : ["profile_id = ?", owner.id]
    result = Article.video_gallery.find(
      :all,
      :order => 'created_at desc',
      :conditions => conditions)
  end

  should "show a gallery which I own" do
    @me = create_user('testuser').person
    @video_gallery = VideoPlugin::VideoGallery.new


    #assert  VideoPlugin.extra_blocks.keys.include?(VideoPlugin::VideoBlock)
  end

end
