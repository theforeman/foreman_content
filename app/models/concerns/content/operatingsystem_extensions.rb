module Content::OperatingsystemExtensions
  extend ActiveSupport::Concern

  included do
    has_many :repositories, :class_name => 'Content::Repository'

    has_many :available_content_views, :dependent => :destroy, :class_name => 'Content::AvailableContentView'
    has_many :content_views, :as => :originator, :class_name => 'Content::ContentView'

    scope :has_repos, joins(:repositories).uniq
  end

end