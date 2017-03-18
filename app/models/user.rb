class User < ActiveRecord::Base
  enum kind: [:journalist, :pagination, :manager]
  enum status: [:active, :inactive]

  has_many :annotations

end
