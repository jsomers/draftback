class DraftsController < ApplicationController
  require 'digest'
  require 'htmlentities'
  
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
  end
end
