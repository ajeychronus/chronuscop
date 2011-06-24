class Project < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  has_many :translations, :dependent => :destroy
end
