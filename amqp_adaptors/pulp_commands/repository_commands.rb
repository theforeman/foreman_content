module PulpCommands
  class Repositories
    def create(attrs)
      # assume library for the time being,
      #if we are in library, no need for an distributor, but need to sync
      importer = generate_importer(attrs)
      #if not in library, no need for sync info, but we need a distributor: importer = Runcible::Extensions::YumImporter.new

      distributors = [generate_distributor(attrs)]

      Runcible::Extensions::Repository.create_with_importer_and_distributors(attrs['pulp_id'],
          importer,
          distributors,
          {:display_name=>attrs['name'], :description => attrs['description']})
    end

    def generate_importer(attrs)
      case attrs['content_type']
        when 'yum'
          Runcible::Extensions::YumImporter.new(:ssl_ca_cert=>attrs['feed_ca'],
                        :ssl_client_cert=>attrs['feed_cert'],
                        :ssl_client_key=>attrs['feed_key'],
                        :feed_url=>attrs['feed'])
        when 'file'
          Runcible::Extensions::IsoImporter.new(:ssl_ca_cert=>attrs['feed_ca'],
                        :ssl_client_cert=>attrs['feed_cert'],
                        :ssl_client_key=>attrs['feed_key'],
                        :feed_url=>attrs['feed'])
        else
          raise "Unexpected repo type %s" % attrs['content_type']
      end
    end

    def generate_distributor(attrs)
      case attrs['content_type']
        when 'yum'
          Runcible::Extensions::YumDistributor.new(attrs['relative_path'], (attrs['unprotected'] || false), true,
                  {:protected=>true, :id=>attrs['pulp_id'],
                      :auto_publish=>true})
        when 'file'
          dist = Runcible::Extensions::IsoDistributor.new(true, true)
          dist.auto_publish = true
          dist
        else
          raise "Unexpected repo type %s" % attrs['content_type']
      end
    end
  end
end
