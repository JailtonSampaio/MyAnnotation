class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum kind: [:journalist, :pagination, :manager]
  enum status: [:active, :inactive]

  has_many :annotations

end
