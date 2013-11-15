require 'sinatra'
require './plotter'

get '/' do
  @terms_input = 'mond, zei, zegt, zeggen, spreken, keel, lippen, woord, horen'
  terms = @terms_input.gsub(/\s+/m, '').strip.split(",")
  term_distances = TermDistances.new( terms )
  @matches = term_distances.matches
  @dists = term_distances.dists
  erb :index
end

post '/' do
  @terms_input = params[ 'terms' ]
  terms = @terms_input.gsub(/\s+/m, '').strip.split(",")
  term_distances = TermDistances.new( terms )
  @matches = term_distances.matches
  @dists = term_distances.dists
  erb :index
end