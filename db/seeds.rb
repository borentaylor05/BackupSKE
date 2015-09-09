# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


clients = ["all", "arc", "ww", "fairfax", "spark", "cdc", "hrsa", "hyundai"]

clients.each do |client|
	token = Client.generate_token(10)
	Client.create!(name: client, token: token)
end
