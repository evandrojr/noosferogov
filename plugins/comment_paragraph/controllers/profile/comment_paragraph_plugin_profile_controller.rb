require 'csv'
class CommentParagraphPluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  def view_comments
    @article_id = params[:article_id]
    @paragraph_uuid = params[:paragraph_uuid]
    article = profile.articles.find(@article_id)
    @comments = article.comments.without_spam.in_paragraph(@paragraph_uuid)
    @comments_count = @comments.count
    @comments = @comments.without_reply
    render :partial => 'comment/comment.html.erb', :collection => @comments
  end

  def export_comments
    article_id = params[:id]
    article = profile.articles.find(article_id)
    doc =  Nokogiri::HTML(article.body)
    comments = article.comments
    commentsMap = comments.group_by { |cmt| cmt.paragraph_uuid }
    @export = []
    doc.css("[data-macro-paragraph_uuid]").map do |paragraph|
      uuid = paragraph.attributes['data-macro-paragraph_uuid'].value    
      comments_for_paragraph = commentsMap[uuid]
      if comments_for_paragraph
        # Put comments for the paragraph
        comments_for_paragraph.each do | cmt |
          element = Hash.new
          paragraph_text = paragraph.present? ? paragraph.text : nil
          element["paragraph_text"] = paragraph_text          
          element["comment_id"] = cmt.id
          element["comment_content"] = cmt.body
          element["comment_author_name"] = cmt.author_name
          element["comment_author_email"] = cmt.author_email
          @export << element
        end
      else
        # There are no comments for this paragraph
        element = Hash.new
        paragraph_text = paragraph.present? ? paragraph.text : nil
        element["paragraph_text"] = paragraph_text
        @export << element
      end
    end
    # Now we need to put all other comments that are not attached to a paragraph
    comments_without_paragrah = commentsMap[nil]
    if (comments_without_paragrah)
      comments_without_paragrah.each do | cmt |
        element = Hash.new
        element["paragraph_text"] = ""
        element["comment_id"] = cmt.id
        element["comment_content"] = cmt.body
        element["comment_author_name"] = cmt.author_name
        element["comment_author_email"] = cmt.author_email
        @export << element
      end
    end
    if (@export.first)
      column_names = @export.first.keys
      header = "Comments for article[#{article_id}]: #{article.path}\n\n"
      s=CSV.generate do |csv|
        csv << column_names
        @export.each do |x|
          csv << x.values
        end
      end
      result = header + s
    else
      result = "No comments for article[#{article_id}]: #{article.path}\n\n"
    end
    fname = "comments_for_article#{article_id}_#{DateTime.now.to_i}.csv"
    send_data result, 
      :type => 'text/csv; charset=UTF-8; header=present',
      :disposition => "attachment; filename=#{fname}"    
  end



end
