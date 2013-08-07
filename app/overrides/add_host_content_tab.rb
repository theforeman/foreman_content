Deface::Override.new(:virtual_path => "hosts/_form",
                     :name => "add_content_tab",
                     :insert_after => 'ul.nav > li a#params-tab',
                     :partial => 'content/content_views/form_tab')

Deface::Override.new(:virtual_path => "hosts/_form",
                     :name => "add_content_tab_pane",
                     :insert_after => 'div.tab-pane#params',
                     :partial => 'content/content_views/host_tab_pane')
