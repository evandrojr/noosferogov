require_dependency File.dirname(__FILE__) + '/video_block'
require_dependency File.dirname(__FILE__) + '/video'
require_dependency File.dirname(__FILE__) + '/video_gallery'

class VideoPlugin < Noosfero::Plugin

  def self.plugin_name
    "Video Content type, Video Block and Video Gallery Plugin"
  end

  def self.plugin_description
    _("A plugin that adds a block where you can add videos from youtube, vimeo and html5.")
  end

  def self.extra_blocks
  {
      VideoBlock => {}
  }
  end
  
  def stylesheet?
    true
  end
  
  def content_types
    [VideoPlugin::VideoGallery, VideoPlugin::Video]
  end  

  def content_remove_new(content)
    if content.kind_of?(VideoPlugin::VideoGallery) or content.kind_of?(VideoPlugin::Video)
      true
    end
  end

  def content_remove_upload(content)
    if content.kind_of?(VideoPlugin::VideoGallery) or content.kind_of?(VideoPlugin::Video)
      true
    end
  end  
  
  def article_extra_toolbar_buttons(content)
    if content.kind_of?(VideoPlugin::VideoGallery)
      proc do
        content_tag('a', _("New Video"),
        { :id=>"new-video-btn",
          :class=>"button with-text icon-new",
          :href=>url_for(:action => 'new', :type=>'Video', :controller=>'cms'),
          :title=>_("New Video")
        })
      end        
    end
  end
  
end
