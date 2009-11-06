class User < ActiveRecord::Base
  has_many :drafts
end
