class Content::Pulp::RepositorySyncHistory
  attr_reader :exception, :removed_count, :started, :completed,
    :error_message, :added_count, :updated_count, :details, :result

  def initialize(attrs)
    attrs.each do |k, v|
      instance_variable_set("@#{k}", v) if respond_to?("#{k}".to_sym)
    end
  end

  def times
    {
      :comps    => summary[:time_total_sec],
      :errata   => summary[:errata_time_total_sec],
      :packages => (summary[:packages][:time_total_sec] rescue 0)
    }
  end

  def metrics
    {
      :updated => updated_count,
      :removed => removed_count,
      :added   => added_count,
    }
  end

  def status
    {
      :result    => result,
      :message   => error_message || summary['error'],
      :completed => completed
    }
  end

  private

  def summary
    @summary ||= Hash.new(0)
  end

end
