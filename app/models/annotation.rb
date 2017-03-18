class Annotation < ActiveRecord::Base
  belongs_to :user
  enum status: [:active, :inactive]
end
