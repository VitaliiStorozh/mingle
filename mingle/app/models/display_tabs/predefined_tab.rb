#  Copyright 2020 ThoughtWorks, Inc.
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#  
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.

require File.join(File.dirname(__FILE__), 'base_tab')

class DisplayTabs
  class PredefinedTab < BaseTab
    def initialize(project, access_key=nil, image_name="")
      @project = project

      @access_key = access_key
      @image_name = image_name
    end

    def identifier
      name
    end

    def dirty?
      false # You cannot change a built-in tab
    end

    def allows_renaming?
      false
    end

    def tab_type
      name
    end

  end
end
