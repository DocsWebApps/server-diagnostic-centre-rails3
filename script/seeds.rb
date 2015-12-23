# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

role=Role.create name: 'Admin', description: 'Admin Role'

role.users.create(name: "Dave Elsby", email: "admin@admin.com", password: "admin@admin.com", password_confirmation: "admin@admin.com")

Server.create([{host_name: "gabon"},{host_name: "cyprus"},{host_name: "uganda"},{host_name: "poland"},{host_name: "france"},{host_name: "belgium"},{host_name: "brunei"},{host_name: "lesotho"},{host_name: "germany"},{host_name: "cameroon"},{host_name: "bulgaria"},{host_name: "malawi"},{host_name: "mali"},{host_name: "greece"},{host_name: "hungary"},{host_name: "egypt"},{host_name: "somalia"},{host_name: "monoco"},{host_name: "tunisia"},{host_name: "italy"},{host_name: "congo"},{host_name: "togo"},{host_name: "moldova"},{host_name: "wales"}])

puts "Seed data loaded OK"