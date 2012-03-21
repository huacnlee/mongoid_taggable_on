# coding: utf-8
require "spec_helper"

describe "Mongoid::TaggableOn" do
  after do
    Movie.delete_all
  end
  
  it "does use tag_list field" do
    m = Movie.new
    m.actor_list = "Jason Statham, Joseph Gordon-Levitt, Johnny Depp, Nicolas Cage"
    m.actors.should == ["Jason Statham", "Joseph Gordon-Levitt", "Johnny Depp", "Nicolas Cage"]
    m.countries = ["United States","China","Mexico"]
    m.country_list.should == "United States,China,Mexico"
    m.save
    m.reload
    m.countries.should == ["United States","China","Mexico"]
    m.country_list.should == "United States,China,Mexico"
  end
  
  it "should split space and remove dupcate items" do
    m = Movie.new
    m.actor_list = "Jason Statham, Joseph Gordon-Levitt, Jason Statham , Johnny Depp, Nicolas Cage"
    m.actors.should == ["Jason Statham", "Joseph Gordon-Levitt", "Johnny Depp", "Nicolas Cage"]
  end
  
  it "should split with other chars" do
    m = Movie.new
    m.actor_list = "Ruby|Rails,Python，web.py，Go"
    m.actors.should == ["Ruby", "Rails", "Python", "web.py","Go"]
  end
  
  it "work for Chinese" do
    m = Movie.new
    m.actor_list = "成龙，李连杰，甄子丹"
    m.actors.should == ["成龙","李连杰","甄子丹"]
  end
end