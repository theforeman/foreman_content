# foreman\_content

This plugin aims to enable repository synconrinzation and managament in Foreman. It is of alpha quality
right now and currently handles only yum/rpm repositories ;)

# Dependencies

* Foreman running development or 1.2.1 (maybe 1.2 but was not tested)
* You must have a fully working pulp server, see http://www.pulpproject.org/docs/


# Installation

Require the gem in Foreman by creating `bundler.d/Gemfile.local.rb` with the
following:

```
gem 'foreman_content'
```

Update & Restart Foreman:
```
bundle update
rake db:migrate
touch tmp/restart.txt (if using passeger)
```

# Configuration

## Pulp
* enable oauth authentication
* make sure you have enough disk space! lots of GB to /var/lib/pulp and /var/lib/mongo

## UI config

You would need to allow foreman to communicate with pulp, under More ->
Settings -> Content, you would need to enable pulp, and set the pulp url and
oauth creds, for example:

  * pulp_oauth_key  foreman
  * pulp_oauth_secret super_secret
  * pulp_url  https://pulp.server.com/pulp/api/v2/
  * use_pulp  true

# Usage

## Setting up

You would see in the UI under More, a new sub menu called content, in it:

* Product    - The actual product you are managing, for example CentOS 6
* Repository - list of repositories that belong to the above product, for
example, CentOS 6.4 + CentOS updates.
* Content View - a collection of cloned repositories

## Create a Product

If you are planning to sync non OS packages (e.g. 3rd party yum repo), you should first create a product, e.g. Foreman 1.2-stable, afterwards, you can add repositories to it.

## Syncing Repositories

Under Content -> Repository create a new repo

* Name - user friendly name, this would be reflected later on in yum configuration
* Feed URL - where we are cloning from, normally a public mirror
* Content type - Kickstart (e.g. bootable) or a plain yum repo, if the repo
contains a full OS, choose kickstart, later on foreman would use that instead
of an Installation media.
* Architecture - type of files within the repo, usually X86_64 or noarch etc.
* Operating Systems - list of valid OS's that this repo applies to.
* Enabled - true / false
* Product - the product from above.
* GPG key - not implemented

Once created, the repo would automatically be synced but not yet visible for
end users, for that you would need to create a Content View.

## Creating Content Views

Content Views, are a collection of immutibal repositories, these repositories
are cloned from the synced repository and allow you to have multiple
repositories definitions per Operation Systems, Custom yum repos, and
Hostgroups.

You would first need to create a content view per Product / Operation system.

## Configuring Hostgroups (and hosts) to consume content views

In your hostgroup definiton, you can select the operation system and the custom
products you are interested in.

next under the content view, you can create a new hostgroup content view, and
select the releavnt content view you would like to consume within your hostgroup.

You could also define the puppet environment(s) in which the content view is
used.

## Consuming Repos within your Kickstart

Once a kickstart repo has been assigned to an OS, it would automatically prefer
that repo as an install media, so if that is all you want to do, its done
automatically.

if you wish to add more yum type repos during KS, you may add the following
snippet to your provisioning template.

```erb
<% @repos.each do |repo| %>
repo --name=<%= repo[:name] %> --baseurl=<%= repo[:baseurl] %>
<% end %>
```

## Consuming Repos with Puppet

Assuming you are using puppet with ENC functionality, its pretty simple to
let puppet manage the repositories, Foreman would expose all repository
information via the ENC as a global parameter, you can later on simply consume
it with create resources, e.g:

```puppet
if $::repositories {
  create_resources('yumrepo', $::repositories)
}
```

## Callback notifications from pulp

Pulp can notify foreman when events happen (e.g. repo sync is finished etc), in
order to configure it run on your pulp server:

```
pulp-admin event listener http create --event-type '*' --url https://foreman.example.com/api/repositories/events
```

# TODO

* https://trello.com/b/NtzVcPkD/foreman-backlog
filter engine spike

# License

foreman_content plugin
Copyright (c) 2013 Red Hat Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
