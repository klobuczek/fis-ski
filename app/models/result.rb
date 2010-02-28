class Result < ActiveRecord::Base
  include FisModel
  belongs_to :competitor
end
