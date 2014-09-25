class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :request
  has_many :comments, :as => :commentable
end
