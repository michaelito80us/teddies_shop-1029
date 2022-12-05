# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Cleaning database...'
Category.destroy_all
Teddy.destroy_all

puts 'Creating categories...'
geek = Category.create!(name: 'geek')
kids = Category.create!(name: 'kids')

puts 'Creating teddies...'
Teddy.create!(sku: 'original-teddy-bear', price_cents: 1, name: 'Teddy bear', category: kids, photo_url: 'https://cdn.pixabay.com/photo/2017/09/21/09/25/teddy-bear-2771252_960_720.jpg')

Teddy.create!(sku: 'lotter', name: "L'otter", price_cents: 1, category: geek, photo_url: 'https://images-na.ssl-images-amazon.com/images/I/81V39H87-EL._AC_SX522_.jpg')
Teddy.create!(sku: 'octocat', name: 'Octocat -  GitHub', price_cents: 1, category: geek, photo_url: 'https://cdn.thenewstack.io/media/2014/11/githubfigurine-1024x539.jpg')
puts 'Finished!'
