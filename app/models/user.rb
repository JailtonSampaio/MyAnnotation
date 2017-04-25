class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :registerable :recoverable :rememberable
  devise :database_authenticatable,
          :validatable,:trackable
  enum kind: [:journalist, :portal, :pagination, :editor, :manager, :super]
  enum status: [:active, :inactive]


  mount_uploader :avatar, PhotoUploader

  has_many :annotations
  def active_for_authentication?
        # Uncomment the below debug statement to view the properties of the returned self model values.
        # logger.debug self.to_yaml

        super && status == "active"
    end

end
