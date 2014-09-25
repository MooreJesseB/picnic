class Request < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_many :comments, :as => :commentable
end
