class Translation < ActiveRecord::Base
  attr_accessible :key
  attr_accessible :value

  belongs_to :projects
end
