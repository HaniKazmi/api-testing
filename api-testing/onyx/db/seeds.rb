# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create( name: 'Hani', role: "admin", photo: "/photos/121")
users.filles.create(filename: "Test", location: "Wirk", size: 2121)
users.filles.create(filename: "Test2", location: "asa", size: 1)