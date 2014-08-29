# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)      not null
#  session_token   :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  attr_reader :password
  
  validates :username, :session_token, :password_digest, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 4 }, allow_nil: true
  after_initialize :ensure_session_token
  
  has_many(
    :moderated_subs,
    primary_key: :id,
    foreign_key: :moderator_id,
    class_name: "Sub"
  )
  
  has_many(
    :posts,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: "Post"
  ) 
  
  def self.generate_token
    SecureRandom.urlsafe_base64
  end
  
  def self.find_by_credentials(username, password)
    found_user = User.find_by(username: username)
    
    return nil if found_user.nil?
    if found_user.is_password? password
      found_user
    else
      nil
    end
  end
  
  def ensure_session_token
    self.session_token ||= User.generate_token
  end
  
  def is_password?(password)

    BCrypt::Password.new(self.password_digest).is_password? password
  end
  
  def password=(password)
    return unless password.present?
    
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end
  
  def reset_session_token!
    self.session_token = User.generate_token
    self.save!
    self.session_token
  end
  
end
