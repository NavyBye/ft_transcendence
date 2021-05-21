json.array! @history_relations do |hr|
  json.game_type hr.history.game_type
  json.is_addon hr.history.is_addon
  json.my_score hr.score
  json.opposite_user do
    json.id hr.opposite.user.id
    json.name hr.opposite.user.name
    json.nickname hr.opposite.user.nickname
  end
  json.opposite_score hr.opposite.score
  json.when hr.history.created_at
end
