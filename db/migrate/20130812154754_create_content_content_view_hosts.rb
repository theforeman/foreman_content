class CreateContentContentViewHosts < ActiveRecord::Migration
  def change
    create_table :content_content_view_hosts do |t|
      t.references :host, :null =>false
      t.references :content_view, :null =>false
    end
    add_index(:content_content_view_hosts, [:content_view_id, :host_id],:name=>'content_content_view_hosts_index', :unique=>true)
  end
end
