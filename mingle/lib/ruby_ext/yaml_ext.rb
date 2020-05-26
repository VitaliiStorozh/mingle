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

module YAML

  def fix_encoding_and_load(yaml)
    yaml = MingleUpgradeHelper.fix_string_encoding_19(yaml) if MingleUpgradeHelper.ruby_1_9?
    load(yaml)
  end

  def render_file_and_load(file_name, context=TOPLEVEL_BINDING)
    fix_encoding_and_load(ERB.new(IO.read(file_name)).result(context))
  end

  module_function :render_file_and_load, :fix_encoding_and_load
end
