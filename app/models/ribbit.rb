class Ribbit < ActiveRecord::Base
  default_scope {order("created_at DESC")}

  belongs_to :user

  validates :content, length: {maximum: 160}
end