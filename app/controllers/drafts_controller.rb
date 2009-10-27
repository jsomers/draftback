class DraftsController < ApplicationController
  require 'digest'
  require 'htmlentities'
  require 'stanfordparser'
  
  def compose
    @drft = Draft.find_by_url(params[:id])
    if !@drft
      redirect_to :controller => "drafts", :action => "create", :draft_id => params[:id]
    else
      @title = "#{@drft.url}"
    end
  end

  def create
    @the_url = params[:draft_id]
  end
  
  def new
    url = params[:draft_url]
    d = Draft.new(:url => url, :public_url => Digest::SHA256.new.hexdigest(url).first(7))
    d.save
    redirect_to "/drafts/compose/#{params[:draft_url]}"
  end
  
  def save
    drft = Draft.find(params[:draft_id].to_i)
    drft.content = HTMLEntities.new.encode(params[:content])
    drft.title = params[:title]
    drft.updated_at = Time.new
    drft.save
    render :json => drft
  end
  
  def review
    @drft = Draft.find_by_public_url(params[:id])
    if session[:review_id].nil?
      reviewified = @drft.reviewify
      rev = Review.new(:draft_id => @drft.id, :n_sentences => reviewified[:n_sentences])
      rev.save
      session[:review_id] = rev.id
      @content = reviewified[:content]
      @n_zeros = reviewified[:n_sentences]
    else
      @content = HTMLEntities.new.decode(Review.find(session[:review_id]).content)
      @n_zeros = Review.find(session[:review_id]).n_sentences
      @general_comments = Review.find(session[:review_id]).general_comments
      if @content.nil?
        reviewified = @drft.reviewify
        @content = reviewified[:content]
        @n_zeros = reviewified[:n_sentences]
      end
    end
  end
  
  def save_review
    rev = Review.find(session[:review_id])
    rev.content = HTMLEntities.new.encode(params[:content])
    rev.signature = params[:signature] unless params[:signature].empty?
    rev.general_comments = params[:general_comments] unless params[:general_comments].empty?
    rev.updated_at = Time.new
    rev.save
    render :json => Time.new
  end
end
