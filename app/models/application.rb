class Application < ApplicationRecord
  belongs_to :user
  validates :status, presence: true, inclusion: { in: ["申请中","已同意","已拒绝"], message: "%{value}不合法" }
  validates :start_day, presence:true
  validates :end_day, presence:true
end
