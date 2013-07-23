Deface::Override.new(:virtual_path => "hostgroups/_form",
                     :name => "add_content_tab",
                     :insert_after => 'ul.nav > code[erb-silent]:contains("show_organization_tab?") ~ code[erb-silent]:contains("end")',
                     :partial => 'content/products/hostgroup_tab')

Deface::Override.new(:virtual_path => "hostgroups/_form",
                     :name => "add_content_tab_pane",
                     :insert_after => 'div.tab-content > code[erb-silent]:contains("show_organization_tab?") ~ code[erb-silent]:contains("end")',
                     :partial => 'content/products/hostgroup_tab_pane')