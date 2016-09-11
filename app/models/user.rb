class User < ApplicationRecord
  has_secure_password

  default_scope -> {order('created_at DESC')}
  has_many :applications
  validates :name, presence: true,length: {maximum: 6}

  REGEX = /\A[ \w+\-. ]+@[ a-z\d\-. ]+\.[ a-z ]+\z/i
  validates :email, presence: true, format: { with: REGEX }, uniqueness: true

  attr_accessor :password
  validates :password, length: {minimum: 6}, if: ->{ password }

  has_many :relations, foreign_key: "staff_id", dependent: :destroy
  has_many :staff_users, through: :relations, source: :staff

  # name_old, name_new
  def add_to_department?
     relations.find_by(self.id)
  end

  def add_to_department!(manager)
    relations.create(manager_id: manager.id)
  end

end
