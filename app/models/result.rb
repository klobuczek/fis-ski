class Result < ActiveRecord::Base
  include FisModel
  belongs_to :competitor
  belongs_to :race

  named_scope :for, lambda { |season, gender, category|
    cat = Category.new :season => season, :category => category
    {:include => [:competitor, :race], :conditions => { :races => { :season => season, :gender => gender}, :competitors => { :year => cat.min_year..cat.max_year }}}
  } do
    def group_by_competitor
      inject({}) do |h, r|
        ((h[r.competitor.id] ||= r.competitor).results ||= []) << r
        h
      end.values
    end
  end

  def cup_points
    @cup_points ||=
            (rank <= 3 ? 30 - 5*rank : rank <= 15 ? 16 - rank : 0)*race.factor
  end
end