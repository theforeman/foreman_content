class Content::Pulp::RepositoryClone < Content::Pulp::Repository
  PULP_SELECT_FIELDS = ['name', 'epoch', 'version', 'release', 'arch', 'checksumtype', 'checksum']

  def copy_from(src_repo_id)
    # In order to reduce the memory usage of pulp during the copy process,
    # include the fields that will uniquely identify the rpm. If no fields
    # are listed, pulp will retrieve every field it knows about for the rpm
    # (e.g. changelog, filelist...etc).
    Runcible::Extensions::Rpm.copy(src_repo_id, repo_id, { :fields => PULP_SELECT_FIELDS })
    Runcible::Extensions::Distribution.copy(src_repo_id, repo_id)

    # Since the rpms will be copied above, during the copy of errata and package groups,
    # include the copy_children flag to request that pulp skip copying them again.
    Runcible::Extensions::Errata.copy(src_repo_id, repo_id, { :copy_children => false })
    Runcible::Extensions::PackageGroup.copy(src_repo_id, repo_id, { :copy_children => false })
    Runcible::Extensions::YumRepoMetadataFile.copy(src_repo_id, repo_id)
  end

  def defaults; end

  def pulp_importer
    Runcible::Extensions::YumImporter.new
  end
end
