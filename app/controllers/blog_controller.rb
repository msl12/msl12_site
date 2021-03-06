class BlogController < ApplicationController

	def index
		  @blogs = Blog.order('id DESC').paginate(page: params[:page])
	end

	def show
		@blog = Blog.find(params[:id].to_i)
		 respond_to do |format|
		 	format.md
		 	format.html { @blog.increment_view_count }
      		end
	end

	def tag
		@blogs = Blog.tagged_with(params[:name]).order('id DESC').paginate(page: params[:page])
		if @blogs.blank?
			return halt_404
		end
	end

	def tag_cloud

	end

	def create_comment
		return false unless account_login?
		blog = Blog.find(params[:id])
		@comment = blog.comments.new
		@comment.account = current_account
		@comment.content = blog_comment_params[:content]
		@comment.save
		render 'create_comment'
	end

	def comment
		@comment = BlogComment.find(params[:id])
		if account_admin?
			@comment.destroy
			render 'delete_comment'
		else
			return halt_403
		end
	end

	def quote_comment
		return false unless account_login?
		return false unless params[:id]
		@comment = BlogComment.find(params[:id].to_i)
		@body = "> #{@comment.account.name} 评论:\n"
		@comment.content.gsub(/\n{3,}/, "\n\n").split("\n").each {|line| @body << "> #{line}\n"}
		@body << "\n"
		render 'quote_comment', :layout => false
	end

	def comment_preview
		return false unless account_login?
		@preview = GitHub::Markdown.to_html(params[:term], :gfm) if params[:term]
		render partial: 'comment_preview'
	end

	private
	def blog_comment_params
		params.require(:blog_comment).permit(:content)
	end

end