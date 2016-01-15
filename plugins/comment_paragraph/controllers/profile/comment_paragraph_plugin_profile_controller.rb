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

  include CommentParagraphPlugin::CommentsReport

  def export_comments
    article_id = params[:id]
    article = profile.articles.find(article_id)
    result = export_comments_csv(article)
    filename = "comments_for_article#{article_id}_#{DateTime.now.to_i}.csv"
    send_data result,
      :type => 'text/csv; charset=UTF-8; header=present',
      :disposition => "attachment; filename=#{filename}"
  end

end
