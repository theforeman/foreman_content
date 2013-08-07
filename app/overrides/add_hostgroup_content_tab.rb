Deface::Override.new(:virtual_path => "hostgroups/_form",
                     :name => "add_content_tab",
                     :insert_after => 'ul.nav > li a#params-tab',
                     :partial => 'content/products/form_tab')

Deface::Override.new(:virtual_path => "hostgroups/_form",
                     :name => "add_content_tab_pane",
                     :insert_after => 'div.tab-pane#params',
                     :partial => 'content/products/hostgroup_tab_pane')
