class History < ApplicationRecord
  # associations
  has_many :history_relations, class_name: "HistoryUser", inverse_of: :history, foreign_key: :history_id,
                               dependent: :destroy
  has_many :users, through: :history_relations, source: :user
end
