class HistoryUser < ApplicationRecord
  # associations
  belongs_to :user, class_name: "User", foreign_key: :user_id, inverse_of: :history_relations
  belongs_to :history, class_name: "History", foreign_key: :history_id, inverse_of: :history_relations
end
