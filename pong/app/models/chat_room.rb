require 'bcrypt'
class ChatRoom < ApplicationRecord
  include BCrypt

  has_many :users, through: :chat_rooms_members
  has_many :messages, class_name: "ChatRoomMessage"

  validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 10 }
  validates :password, allow_nil: true, length: { minimum: 4, maximum: 10 }

  before_validation :strip_name, only: [:name]

  attr_reader :password

  def password=(unencrypted_password)
    @password = unencrypted_password
    self.encrypted_password = @password && Password.create(unencrypted_password)
  end

  def public
    encrypted_password.nil?
  end

  private

  def strip_name
    self.name = name.strip unless name.nil?
  end
end
