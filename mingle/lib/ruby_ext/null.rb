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

class Null
  class << self
    def instance(overrides = {})
      self.new.define_overrides(overrides)
    end  
  end
  
  #override Object#id for removing the warning
  def id
    nil
  end
  
  def method_missing(sym, *args, &block)
    nil
  end  
  
  def define_overrides(overrides)
    overrides.each_pair do |key, value|
      (class << self; self; end;).send(:define_method, key, lambda { value })
    end
    self  
  end
end
