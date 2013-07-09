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

module Repositories
  class GpgKey < ActiveRecord::Base

    MAX_CONTENT_LENGTH = 100000

    has_many :repositories, :inverse_of => :gpg_key
    has_many :products, :inverse_of => :gpg_key

    validates :name, :presence => true
    validates_with Validators::NameFormat, :attributes => :name
    validates :content, :presence => true
    validates_with Validators::ContentValidator, :attributes => :content
    validates_length_of :content, :maximum => MAX_CONTENT_LENGTH

    validates_uniqueness_of :name, :message => N_("Label has already been taken")

    scoped_search :on => :name

  end
end
