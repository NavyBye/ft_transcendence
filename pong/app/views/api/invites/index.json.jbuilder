json.array! @invitations do |invitation|
  json.id invitation.id
  json.guild do
    json.id invitation.guild.id
    json.name invitation.guild.name
    json.anagram invitation.guild.anagram
  end
end
