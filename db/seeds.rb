require 'json'
require 'open-uri'
require 'faker'
# Nettoyer la base de données
puts "Cleaning database..."
Bookmark.destroy_all
Movie.destroy_all
List.destroy_all
puts "Database cleaned!"
# 1. Ajouter des films statiques donnés dans l’exercice
puts "Adding static movies..."
Movie.create!(
  title: "Wonder Woman 1984",
  overview: "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s.",
  poster_url: "https://image.tmdb.org/t/p/original/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg",
  rating: 6.9
)
Movie.create!(
  title: "The Shawshank Redemption",
  overview: "Framed in the 1940s for double murder, upstanding banker Andy Dufresne begins a new life at the Shawshank prison.",
  poster_url: "https://image.tmdb.org/t/p/original/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
  rating: 8.7
)
Movie.create!(
  title: "Titanic",
  overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic.",
  poster_url: "https://image.tmdb.org/t/p/original/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg",
  rating: 7.9
)
Movie.create!(
  title: "Ocean's Eight",
  overview: "Debbie Ocean, a criminal mastermind, gathers a crew of female thieves to pull off the heist of the century.",
  poster_url: "https://image.tmdb.org/t/p/original/MvYpKlpFukTivnlBhizGbkAe3v.jpg",
  rating: 7.0
)
puts "Static movies added!"
# 2. Ajouter des films aléatoires avec Faker (optionnel)
puts "Adding random movies with Faker..."
10.times do
  Movie.create!(
    title: Faker::Movie.title,
    overview: Faker::Lorem.paragraph(sentence_count: 2),
    poster_url: "https://via.placeholder.com/150", # Placeholder image
    rating: rand(1.0..10.0).round(1)
  )
end
puts "Random movies added!"
# 3. Récupérer des films via l'API TMDB (optionnel)
puts "Fetching movies from TMDB..."
url = "https://tmdb.lewagon.com/movie/top_rated"
begin
  response = URI.open(url).read
  movies = JSON.parse(response)["results"]
  puts "Number of movies fetched from TMDB: #{movies.count}"
  movies.each do |movie|
    new_movie = Movie.find_or_create_by(
      title: movie["title"]
    ) do |m|
      m.overview = movie["overview"]
      m.poster_url = "https://image.tmdb.org/t/p/w500/#{movie['poster_path']}"
      m.rating = movie["vote_average"]
    end
    puts "Processed movie: #{new_movie.title}"
  end
rescue OpenURI::HTTPError => e
  puts "HTTP Error while fetching TMDB movies: #{e.message}"
rescue JSON::ParserError => e
  puts "JSON Parsing Error while processing TMDB movies: #{e.message}"
rescue => e
  puts "An unexpected error occurred: #{e.message}"
end
puts "Movies from TMDB added!"
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
