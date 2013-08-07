module Content::EnvironmentExtensions
  extend ActiveSupport::Concern

  included do
    has_many :available_content_veiws, :dependent => :destroy, :class_name => 'Content::AvailableContentView'
    has_many :content_views, :through => :available_content_veiws, :class_name => 'Content::ContentView'
  end

end