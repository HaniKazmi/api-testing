# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create( name: 'Hani', role: "admin", photo: "/photos/121")
users.filles.create(filename: "photo.jpg", location: "/resource/12123", size: 12)
users.filles.create(filename: "movie.exe", location: "/resource/3094", size: 194320)

users = User.create( name: 'Newton', role: "User", photo: "/photos/21")
users.filles.create(filename: "game.mp4", location: "/resource/9087", size: 1)
users.filles.create(filename: "kcl.txt", location: "/resource/123", size: 432)