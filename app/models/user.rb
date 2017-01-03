# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string
#  session_token   :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessor :password

  validates :first_name, presence: true, length: { minimum: 1 }
  validates :last_name, presence: true, length: { minimum: 1 }
  validates :email, presence: true, length: { minimum: 4 }

  before_create :generate_new_session_token

  def self.find_by_credentials(email, password)
    user = find_by(email: email)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def generate_new_session_token!
    self.session_token = SecureRandom.urlsafe_base64(32)
    save!
    session_token
  end
end
