module Content::OperatingsystemExtensions
  extend ActiveSupport::Concern

  included do
    has_many :repositories, :class_name => 'Content::Repository'

    has_many :available_content_veiws, :dependent => :destroy, :class_name => 'Content::AvailableContentView'
    has_many :content_views, :through => :available_content_veiws, :class_name => 'Content::ContentView'

    scope :has_repos, includes(:repositories).where('content_repositories.id IS NOT NULL')
  end

end