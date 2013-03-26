class Movie < ActiveRecord::Base
  def self.all_ratings
    #['G','PG','PG-13','R']
    self.find(:all).map(&:rating).uniq
  end
end
