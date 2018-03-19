@localusers = Array.new
for user in group.users
	u = Hash.new
	u[:name] = user.name
	u[:avatar_url] = user.avatar.url(:thumb)
	u[:id] = user.id
	@localusers.push(u)
end
json.id group.id
json.name group.name
json.users @localusers
