# Mongoid Taggable On

Mongoid Taggable provides some helpers to create taggable documents, can use many fields.

## Status

[![CI Status](https://secure.travis-ci.org/huacnlee/mongoid_taggable_on.png)](http://travis-ci.org/huacnlee/mongoid_taggable_on)

## Installation

You can simple install from rubygems:

    gem install mongoid_taggable_on
    
or in Gemfile:

    gem 'mongoid_taggable_on'
    
## Usage

    class Movie
      include Mongoid::Document
      include Mongoid::TaggableOn

      taggable_on :actors, :index => false
      taggable_on :directors
      taggable_on :countries
      
      field :title
      field :summary
    end
    
Now you can use sample:

    irb> m = Movie.new
    irb> m.actors_list = "Jason Statham, Joseph Gordon-Levitt, Johnny Depp, Nicolas Cage"
    irb> m.actors
    ["Jason Statham", "Joseph Gordon-Levitt", "Johnny De", "Nicolas Cage"]
    irb> m.country_list = "United States| China|Mexico"
    irb> m.countries
    ["United States","China","Mexico"]
    
## Allow split chars

    , ，| /
    
