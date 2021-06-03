require 'bcrypt'
class ChatRoom < ApplicationRecord
  include BCrypt

  has_many :chat_rooms_members, dependent: :destroy
  has_many :members, through: :chat_rooms_members, source: :user
  has_many :messages, dependent: :destroy, class_name: "ChatRoomMessage"

  validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 10 }
  validates :password, allow_nil: true, length: { minimum: 4, maximum: 10 }, if: :password_changed?

  before_validation :strip_name, only: [:name]

  attr_accessor :joined

  def password=(unencrypted_password)
    @password = unencrypted_password
    self.encrypted_password = @password && Password.create(unencrypted_password)
  end

  def password
    @password || Password.new(encrypted_password) unless encrypted_password.nil?
  end

  def public
    encrypted_password.nil?
  end

  def change_role(user_id, role)
    ChatRoomsMember.find_by!(user_id: user_id, chat_room_id: id).update! role: role
  end

  def change_status(user_id, status)
    ChatRoomsMember.find_by!(user_id: user_id, chat_room_id: id).update! status: status
  end

  def password_changed?
    !@password.nil?
  end

  private

  def strip_name
    self.name = name.strip unless name.nil?
  end
end
