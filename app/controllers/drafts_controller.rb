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
    redirect_to "/#{params[:draft_url]}"
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
    @draft = Draft.find_by_public_url(params[:id])
    if session[:review_ids].nil? then session[:review_ids] = {} end
    if session[:review_ids][@draft.id].nil? # Time to set up a new review for this <draft, session>.
      reviewified = @draft.reviewify
      rev = Review.new(:draft_id => @draft.id, :n_sentences => reviewified[:n_sentences])
      rev.content = reviewified[:content]
      rev.save
      session[:review_ids][@draft.id] = rev.id
      @content = reviewified[:content]
      @n_zeros = reviewified[:n_sentences]
    else
      rev = Review.find(session[:review_ids][@draft.id])
      @content = HTMLEntities.new.decode(rev.content)
      @n_zeros = rev.n_sentences
      @general_comments = rev.general_comments
      @signature = rev.signature
      if @content.nil?
        reviewified = @draft.reviewify
        @content = reviewified[:content]
        @n_zeros = reviewified[:n_sentences]
      end
    end
  end
  
  def save_review
    rev = Review.find(session[:review_ids][params[:draft_id].to_i])
    rev.content = HTMLEntities.new.encode(params[:content])
    rev.signature = params[:signature] unless params[:signature].empty?
    rev.general_comments = params[:general_comments] unless params[:general_comments].empty?
    rev.updated_at = Time.new
    rev.save
    render :json => Time.new
  end
  
  def refresh_review
    Review.find(session[:review_ids][params[:draft_id].to_i]).destroy
    session[:review_ids][params[:draft_id].to_i] = nil
    redirect_to "/review/#{params[:public_url]}"
  end
  
  def feedback
    @drft = Draft.find_by_url(params[:id])
    @reviews = @drft.reviews.sort {|a, b| a.updated_at <=> b.updated_at}
  end
end