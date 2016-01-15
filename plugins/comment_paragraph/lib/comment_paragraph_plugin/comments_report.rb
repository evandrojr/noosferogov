module CommentParagraphPlugin::CommentsReport

  #FIXME make this test
  def export_comments_csv(article)
    comments_map = article.comments.group_by { |comment| comment.paragraph_uuid }
    @export = []
    doc =  Nokogiri::HTML(article.body)
    doc.css("[data-macro-paragraph_uuid]").map do |paragraph|
      uuid = paragraph.attributes['data-macro-paragraph_uuid'].value
      comments_for_paragraph = comments_map[uuid]
      if comments_for_paragraph
        # Put comments for the paragraph
        comments_for_paragraph.each do | comment |
          @export << create_comment_element(comment, paragraph)
        end
      else # There are no comments for this paragraph
        @export << { paragraph_text: paragraph }
      end
    end
    # Now we need to put all other comments that are not attached to a paragraph
    comments_without_paragrah = comments_map[nil] || []
    comments_without_paragrah.each do | comment |
      @export << create_comment_element(comment, nil)
    end
    return _("No comments for article[%{id}]: %{path}\n\n") % {:id => article.id, :path => article.path} if @export.empty?

    column_names = @export.first.keys
    CSV.generate do |csv|
      csv << column_names
      @export.each { |x| csv << x.values }
    end
  end

  private

  def create_comment_element(comment, paragraph)
    {
      paragraph_text: paragraph.present? ? paragraph.text : nil,
      comment_id: comment.id,
      comment_title: comment.title,
      comment_content: comment.body,
      comment_author_name: comment.author_name,
      comment_author_email: comment.author_email
    }
  end

end
