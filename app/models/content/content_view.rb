module Content
  class ContentView < ActiveRecord::Base
    has_ancestry :orphan_strategy => :rootify
    attr_accessor :repository_ids_to_clone

    belongs_to :originator, :polymorphic => true
    has_many :available_content_views, :dependent => :destroy
    has_many :environments, :through => :available_content_views
    delegate :operatingsystems, :to => :available_content_views, :allow_nil => true

    has_many :content_view_hosts, :dependent => :destroy, :uniq => true, :foreign_key => :content_view_id, :class_name => 'Content::ContentViewHost'
    has_many :hosts, :through => :content_view_hosts

    before_destroy :clean_unused_clone_repos
    has_many :content_view_repository_clones, :dependent => :destroy

    has_many :repository_clones, :through => :content_view_repository_clones,
             :source => :repository, :source_type => 'Content::RepositoryClone'

    has_many :repository_sources, :through => :content_view_repository_clones,
             :source => :repository, :source_type => 'Content::Repository'

    scope :hostgroups, where(:originator_type => 'Hostgroup')
    scope :products, where(:originator_type => 'Content::Product')
    scope :operatingsystem, where(:originator_type => 'Operatingsystem')

    after_create :clone_repos

    validates_presence_of :name
    validates_uniqueness_of :name, :scope => [:originator_id, :originator_type]

    # special relationships needed for search with polymorphic associations
    belongs_to :search_hostgroups, :class_name => 'Hostgroup', :foreign_key => :originator_id,
               :conditions => '"content_content_views"."originator_type" = "Hostgroup"'
    belongs_to :search_operatingsystems, :class_name => 'Operatingsystem', :foreign_key => :originator_id,
               :conditions => '"content_content_views"."originator_type" = "Operatingsystem"'
    belongs_to :search_products, :class_name => 'Content::Product', :foreign_key => :originator_id,
               :conditions => '"content_content_views"."originator_type" = "Content::Product"'
    scoped_search :on => [:name, :created_at], :complete_value => :true
    scoped_search :in => :search_products, :on => :name, :rename => :product,
                  :complete_value => :true, :only_explicit => true
    scoped_search :in => :search_operatingsystems, :on => :name, :rename => :operatingsystem,
                  :complete_value => :true, :only_explicit => true
    scoped_search :in => :search_hostgroups, :on => :label, :complete_value => true,
                  :rename => :hostgroup, :only_explicit => true

    def to_label
      name || "#{originator.to_label} - #{DateTime.now.strftime("%m/%d/%Y")}".parameterize
    end

    private

    def clone_repos
      return unless repository_ids_to_clone
      Repository.where(:id => repository_ids_to_clone).each do |repository|
        repository.clone self
      end
    end

    def clean_unused_clone_repos
      current_repos = Content::ContentViewRepositoryClone.where(:content_view_id => id, :repository_type => 'Content::RepositoryClone').pluck(:repository_id)
      used_repos    = Content::ContentViewRepositoryClone.
        where(:repository_id => current_repos).
        where(['content_view_id IS NOT ?', id]).pluck(:repository_id)

      repos_to_delete = current_repos - used_repos
      logger.debug('All Cloned repositories are used elsewhere, nothing to do') if repos_to_delete.empty?
      logger.debug("Clone Repos IDS: #{repos_to_delete.join(', ')} are unused - deleting...") if repos_to_delete.any?
      Content::RepositoryClone.destroy(repos_to_delete) if repos_to_delete.any?
    end
  end
end
