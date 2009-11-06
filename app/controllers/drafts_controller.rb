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
    if (em = params[:email][/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/])
      u = User.find_by_email(em)
      if u.nil?
        u = User.new(:email => em)
        u.save
        old_timer = false
      else
        old_timer = true
      end
    end
    url = params[:draft_url]
    public_url = Digest::SHA256.new.hexdigest(url).first(7)
    d = Draft.new(
      :user_id => (em ? u.id : nil),
      :url => url, 
      :public_url => public_url,
      :title => "[title goes here]",
      :content => (em && old_timer ? "Welcome back! Delete me and start drafting!" : "<p><h3>Is this your first time?</h3></p>
                   <ol>
                   <li>Use this editor to compose your draft, and remember the URL of this page &mdash; <strong>draftback.com/#{url}</strong> &mdash;
                   so that you can come back later and make changes.</li>
                   
                   <li>Your work will be automatically saved every two minutes, but you can click the \"Save now\" link below if you're 
                   especially anxious.</li>
                   
                   <li>Don't forget to add a clever title using the box just above this editor.</li>
                   
                   <li>When you're finished, send your friends to <strong>draftback.com/review/#{public_url}</strong> (the highlighted link above), 
                   where they'll be able to read and review your work. You may want to preview that page yourself just to see how it works.</li>
                   
                   <li>Finally, " + (em ? "we'll send an e-mail to <strong>#{em}</strong> as soon as someone submits feedback on your draft, and " : "") + 
                   "there will be a page, <strong>draftback.com/feedback/#{url}</strong>, where you can see everyone's comments at a glance.</li>
                   
                   <li>Now delete this nonsense and start drafting!</li>"
                   )
    )
    d.save
    redirect_to "/#{params[:draft_url]}"
  end
  
  def save
    drft = Draft.find(params[:draft_id].to_i)
    drft.content = HTMLEntities.new.encode(params[:content])
    drft.title = params[:title]
    drft.email = params[:email][/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/]
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
      @title_classes = "sentence"
    else
      rev = Review.find(session[:review_ids][@draft.id])
      @content = HTMLEntities.new.decode(rev.content)
      @n_zeros = rev.n_sentences
      @title_classes = rev.title_classes
      @general_comments = rev.general_comments
      @signature = rev.signature
      if @content.nil?
        reviewified = @draft.reviewify
        @content = reviewified[:content]
        @n_zeros = reviewified[:n_sentences]
        @title_classes = "sentence"
      end
    end
  end
  
  def save_review
    rev = Review.find(session[:review_ids][params[:draft_id].to_i])
    rev.content = HTMLEntities.new.encode(params[:content])
    rev.signature = params[:signature] unless params[:signature].empty?
    rev.general_comments = params[:general_comments] unless params[:general_comments].empty?
    rev.title_classes = params[:title_classes]
    rev.updated_at = Time.new
    rev.save
    render :json => Time.new
  end
  
  def refresh_review
    Review.find(session[:review_ids][params[:draft_id].to_i]).destroy
    session[:review_ids][params[:draft_id].to_i] = nil
    redirect_to "/review/#{params[:public_url]}"
  end
  
  def submit_review
    draft = Draft.find(params[:draft_id].to_i)
    if draft.user
      review = Review.find(session[:review_ids][draft.id])
      UserNotifier.deliver_new_review_notification(draft.user, review)
    end
    render :text => "Sent!"
  rescue
    render :text => "Fail"
  end
  
  def feedback
    @drft = Draft.find_by_url(params[:id])
    @reviews = @drft.reviews.sort {|a, b| a.updated_at <=> b.updated_at}
  end
end