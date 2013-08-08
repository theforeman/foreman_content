module Content
  class RepositoryBase < ActiveRecord::Base
    include CustomRepositoryPaths
    attr_reader :pulp
  end
end
