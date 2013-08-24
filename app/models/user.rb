# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  role_id         :integer
#

class User < ActiveRecord::Base
  belongs_to :role
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  before_save { |user| user.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 7 }
  validates :password_confirmation, presence: true
  
  def change_password(new_password)
    self.password=self.password_confirmation=new_password
    self.save
  end
end
