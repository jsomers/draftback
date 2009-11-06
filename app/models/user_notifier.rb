class UserNotifier < ActionMailer::Base
  def new_review_notification(user, review)
    recipients user.email
    from "reviews@draftback.com"
    subject "[draftback.com] new feedback received on " + (!(titl = review.draft.title).empty? ? "\"#{titl}.\"" : "your draft.")
    body (:user => user, :review => review)
  end
end
