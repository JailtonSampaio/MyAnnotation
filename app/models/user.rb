class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :registerable :recoverable :rememberable
  devise :database_authenticatable,
          :validatable,:trackable
  enum kind: [:journalist, :pagination, :manager]
  enum status: [:active, :inactive]
  

  mount_uploader :photo, PhotoUploader

  has_many :annotations

end
