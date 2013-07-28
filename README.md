# foreman\_content

This plugin aims to enable repository synconrinzation and managament in Foreman. It is of alpha quality
right now and currently handles only yum/rpm repositories ;)

# Dependencies

* Foreman running development or 1.2.1 (maybe 1.2 but was not tested)

# Installation

Require the gem in Foreman by creating `bundler.d/Gemfile.local.rb` with the
following:

```
gem 'foreman_content', :git => 'https://github.com/theforeman/foreman_content.git'
```

Update & Restart Foreman:
```
bundle update
rake db:migrate
touch tmp/restart.txt (if using passeger)
```

# Configuration

## Pulp

You must have a fully working pulp server, see http://www.pulpproject.org/docs/

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

* Provider - The content Provider, for example, CentOS, if its a non RHEL
* operation system, use a custom type.
* Product  - The actual product the provider delivers, for example CentOS 6
* Repository - list of repositories that belong to the above product, for
example, CentOS 6.4 + CentOS updates.
* GPG Keys - not implemented really at the moment.

Start by creating a Provider and a Product, these are foreman constructs which
would be used later on.

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
* Unprotected - weather pulp should expose this repo via http and https or just
  over https.
* Product - the product from above.
* GPG key - not implemented

Once created, the repo would automaticiily be synced and published.

## Consuming Repos within your Kickstart

Once a kickstart repo has been assigned to an OS, it would automaticiily prefer
that repo as an install media, so if thats all you want to do, its done
automaticiily.

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

* Write the full todo list
