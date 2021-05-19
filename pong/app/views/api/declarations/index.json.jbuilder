json.array! @guild.declaration_received do |declaration|
  json.id declaration.id
  json.from do
    json.id declaration.from.id
    json.name declaration.from.name
    json.anagram declaration.from.anagram
  end
  json.end_at declaration.end_at
  json.war_time declaration.war_time
  json.avoid_chance declaration.avoid_chance
  json.prize_point declaration.prize_point
  json.is_extended declaration.is_extended
  json.is_addon declaration.is_addon
end
