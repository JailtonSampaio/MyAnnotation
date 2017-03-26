class Annotation < ActiveRecord::Base

  belongs_to :user
  enum status: [:active, :inactive]
  include RailsAdminDynamicCharts::Datetime

end
