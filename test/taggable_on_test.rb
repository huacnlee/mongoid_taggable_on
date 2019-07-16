# frozen_string_literal: true

require "test_helper"

class TaggableOnTest < ActiveSupport::TestCase
  teardown do
    Movie.delete_all
  end

  test "does use tag_list field" do
    movie = Movie.new
    movie.actor_list = "Jason Statham, Joseph Gordon-Levitt, Johnny Depp, Nicolas Cage"
    assert_equal ["Jason Statham", "Joseph Gordon-Levitt", "Johnny Depp", "Nicolas Cage"], movie.actors

    movie.countries = ["United States", "China", "Mexico"]
    assert_equal "United States,China,Mexico", movie.country_list
    movie.save!

    movie.reload
    assert_equal ["United States", "China", "Mexico"], movie.countries
    assert_equal "United States,China,Mexico", movie.country_list
  end

  test "should split space and remove dupcate items" do
    movie = Movie.new
    movie.actor_list = "Jason Statham, Joseph Gordon-Levitt, Jason Statham , Johnny Depp, Nicolas Cage"
    assert_equal ["Jason Statham", "Joseph Gordon-Levitt", "Johnny Depp", "Nicolas Cage"], movie.actors
  end

  test "should split with other chars" do
    movie = Movie.new
    movie.actor_list = "Ruby|Rails,Python，web.py，Go"
    assert_equal ["Ruby", "Rails", "Python", "web.py", "Go"], movie.actors
  end

  test "work for Chinese" do
    movie = Movie.new
    movie.actor_list = "成龙，李连杰，甄子丹"
    assert_equal %w[成龙 李连杰 甄子丹], movie.actors
  end

  test "tagged_with_on can work with all match" do
    Movie.create(category_list: "Ruby,Rails,Python", country_list: "China,Mexico")
    Movie.create(category_list: "Java,Rails,Python", country_list: "China,United States")
    Movie.create(category_list: "Django,Rails,Go")
    Movie.create(category_list: "C,Elang,PHP,Java")

    assert_equal 2, Movie.tagged_with_on(:categories, %w[Rails Python]).count

    # match with any in
    assert_equal 3, Movie.tagged_with_on(:categories, %w[Rails Python], match: :any).count

    # match with not in
    assert_equal 1, Movie.tagged_with_on(:categories, %w[Rails Python], match: :not).count

    # match with string value
    assert_equal 1, Movie.tagged_with_on(:categories, "Java,Rails").count

    # it "match with case insensitive" do
    #   Movie.tagged_with_on(:categories, "jAva,RAILS").count.should == 1
    #   Movie.tagged_with_on(:categories, "php").count.should == 1
    # end

    # match different taggable
    assert_equal 1, Movie.tagged_with_on(:categories, %w[Rails Python]).tagged_with_on(:countries, "United States").count
    assert_equal 2, Movie.tagged_with_on(:categories, %w[Rails Python]).tagged_with_on(:countries, "China").count
  end

  test "changes with Dirty" do
    # should work with _was and _changed?
    movie = Movie.new
    movie.actor_list = "Ruby,Rails"
    movie.save!

    movie.actor_list = "Python,Django"
    assert_equal %w[Ruby Rails], movie.actors_was
    assert_equal "Ruby,Rails", movie.actor_list_was
    assert_equal true, movie.actors_changed?
    assert_equal true, movie.actor_list_changed?
  end
end
