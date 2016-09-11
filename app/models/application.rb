class Application < ApplicationRecord
  belongs_to :user
  default_scope -> {order('created_at DESC')}
  validates :status, presence: true, inclusion: { in: ["申请中","已同意","已拒绝"], message: "%{value}不合法" }
  validates :start_day, presence: true
  validates :end_day, presence: true
  validates :admin_comments, length: {maximum: 30 }
  validates :application_reasons, length: {maximum: 30 }
end
