# coding: utf-8
require "spec_helper"

describe "Mongoid::TaggableOn" do
  after(:all) do
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
  
  describe "tagged_with_on can work with all match" do
    before(:all) do
      Movie.create(:category_list => "Ruby,Rails,Python", :country_list => "China,Mexico")
      Movie.create(:category_list => "Java,Rails,Python", :country_list => "China,United States")
      Movie.create(:category_list => "Django,Rails,Go")
      Movie.create(:category_list => "C,Elang,PHP,Java")
    end
    
    it "match with all in" do
      Movie.tagged_with_on(:categories, ["Rails","Python"]).count.should == 2
    end
    
    it "match with any in" do
      Movie.tagged_with_on(:categories, ["Rails","Python"], :match => :any).count.should == 3
    end
    
    it "match with not in" do
      Movie.tagged_with_on(:categories, ["Rails","Python"], :match => :not).count.should == 2
    end
    
    it "match with string value" do
      Movie.tagged_with_on(:categories, "Java,Rails").count.should == 1
    end
    
    # it "match with case insensitive" do
    #   Movie.tagged_with_on(:categories, "jAva,RAILS").count.should == 1
    #   Movie.tagged_with_on(:categories, "php").count.should == 1
    # end
    
    it "match different taggable" do
      Movie.tagged_with_on(:categories, ["Rails","Python"]).tagged_with_on(:countries,"United States").count.should == 1
      Movie.tagged_with_on(:categories, ["Rails","Python"]).tagged_with_on(:countries,"China").count.should == 2
    end
  end
end