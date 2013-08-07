#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
module Content
  class AvailableContentView < ActiveRecord::Base
    belongs_to :environment
    belongs_to :operatingsystem
    belongs_to :hostgroup
    belongs_to :content_view

    #todo needs to validate that default can't be archived and vice-versa
    #todo needs to validate that os or hostgroup exist but not both
    validates_presence_of :operatingsystem_id, :unless => :hostgroup_id
    validates_presence_of :hostgroup_id, :unless => :operatingsystem_id

  end
end