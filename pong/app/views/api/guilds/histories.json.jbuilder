json.array! @guild.war_history_relations.last(10) do |wh|
  json.is_addon wh.war_history.is_addon
  json.is_extended wh.war_history.is_extended
  json.prize_point wh.war_history.prize_point
  json.my_result wh.result
  json.opposite_guild do
    json.id wh.opposite.guild.id
    json.name wh.opposite.guild.name
    json.anagram wh.opposite.guild.anagram
  end
  json.opposite_result wh.opposite.result
  json.when wh.created_at
end
