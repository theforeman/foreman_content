module Content
  class Repository < ActiveRecord::Base

    YUM_TYPE = 'yum'
    FILE_TYPE = 'file'
    TYPES = [YUM_TYPE, FILE_TYPE]

    belongs_to :product, :inverse_of => :repositories, :class_name => "Content::Product"
    belongs_to :gpg_key, :inverse_of => :repositories, :class_name => "Content::GpgKey"
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


  end
end
