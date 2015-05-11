# Mongoid Taggable On

Mongoid Taggable provides some helpers to create taggable documents, can use many fields.

## Status

- [![Gem Version](https://badge.fury.io/rb/mongoid_taggable_on.png)](https://rubygems.org/gems/mongoid_taggable_on)
- [![CI Status](https://api.travis-ci.org/huacnlee/mongoid_taggable_on.png)](http://travis-ci.org/huacnlee/mongoid_taggable_on)

## Installation

You can simple install from rubygems:

```bash
gem install mongoid_taggable_on
```

or in Gemfile:

```ruby
gem 'mongoid_taggable_on'
```

## Usage

[中文介绍去这里](http://huacnlee.com/blog/new_gem_mongoid_taggable_on)

```ruby
class Movie
  include Mongoid::Document
  include Mongoid::TaggableOn

  taggable_on :actors, :index => false
  taggable_on :directors
  taggable_on :countries

  field :title
  field :summary
end
```

Now you can use sample:

```bash
irb> m = Movie.new
irb> m.actor_list = "Jason Statham, Joseph Gordon-Levitt, Johnny Depp, Nicolas Cage"
irb> m.actors
["Jason Statham", "Joseph Gordon-Levitt", "Johnny De", "Nicolas Cage"]
irb> m.country_list = "United States| China|Mexico"
irb> m.countries
["United States","China","Mexico"]
```

find with tag:

```bash
irb> Movie.tagged_with_on(:actors, "Jason Statham, Joseph Gordon-Levitt")
irb> Movie.tagged_with_on(:actors, "Jason Statham, Joseph Gordon-Levitt", :match => :any)
irb> Movie.tagged_with_on(:actors, "Nicolas Cage", :match => :not)
```

## Allow split chars

    , ，| /

## Who used that?

In [720p.so](http://720p.so), the Movie actors, directors, languages, countries, tags all base in mongoid\_taggable\_on.
