json.array! @members do |member|
  json.id member.id
  json.role member.role
  json.user do
    json.id member.user.id
    json.name member.user.name
    json.nickname member.user.nickname
  end
end
