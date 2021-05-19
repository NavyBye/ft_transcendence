json.id @guild.id
json.name @guild.name
json.anagram @guild.anagram
json.point @guild.point
json.master do
  json.id @master.id
  json.nickname @master.nickname
  json.name @master.name
end
