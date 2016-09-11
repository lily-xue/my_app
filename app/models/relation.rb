class Relation < ApplicationRecord
  belongs_to :manager, class_name: "User"
  belongs_to :staff, class_name: "User"
  validates :manager_id, presence: true
  validates :staff_id, presence: true
end
