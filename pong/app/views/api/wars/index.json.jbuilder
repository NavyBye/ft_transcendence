json.array! @current_war do |war|
  json.id war.id
  json.is_addon war.is_addon
  json.is_extended war.is_extended
  json.prize_point war.prize_point
  json.guilds war.guilds do |guild|
    json.id guild.id
    json.name guild.name
  end
end
