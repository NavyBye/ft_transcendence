class ChatRoom < ApplicationRecord
    validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 10 }
    validates :password, length: { minimum: 4, maximum: 10 } # TODO minimum 조건 존재시 nil 입력가능한지?
end
