# TODO?: split into a custom and red hat repositories:
# as handling of repo creation/updates is different between them
module Content
  class Repository < ActiveRecord::Base
    include CustomRepositoryHelper

    YUM_TYPE = 'yum'
    FILE_TYPE = 'file'
    TYPES = [YUM_TYPE, FILE_TYPE]

    belongs_to :product, :inverse_of => :repositories, :class_name => "Content::Product", :foreign_key => "content_product_id"
    belongs_to :gpg_key, :inverse_of => :repositories, :class_name => "Content::GpgKey", :foreign_key => "content_gpg_key_id"
    belongs_to :architecture, :inverse_of => :repositories
    belongs_to :operatingsystem, :inverse_of => :repositories, :class_name => 'Redhat'

    validates :product, :presence => true
    validates :pulp_id, :presence => true, :uniqueness => true
    validates :name, :presence => true
    # TODO: add relative_path validation (valid url format)

    validates_inclusion_of :content_type,
      :in => TYPES,
      :allow_blank => false,
      :message => (_("Please select content type from one of the following: %s") % TYPES.join(', '))

    scoped_search :on => [:name, :enabled ], :complete_value => :true
    scoped_search :in => :architectures, :on => :name, :rename => :architecture, :complete_value => :true
    scoped_search :in => :operatingsystems, :on => :name, :rename => :os, :complete_value => :true

    # TODO: move this initialization into pulp- and candlepin-specific modules
    before_validation do
      self.content_id = ::SecureRandom.urlsafe_base64(30) # TODO: uuid would probably be better?
      self.pulp_id = ::SecureRandom.urlsafe_base64(30) # TODO: uuid would probably be better?
      self.cp_label = name
      self.relative_path = custom_repo_path("acme_org", "library", product.name, name)
    end

    after_create { ActiveSupport::Notifications.instrument('content.repository.create', :entity => self) }
    after_update { ActiveSupport::Notifications.instrument('content.repository.update', :entity => self) }
    after_destroy { ActiveSupport::Notifications.instrument('content.repository.destroy', :id => id) }
  end
end
