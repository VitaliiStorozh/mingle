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

require File.expand_path(File.dirname(__FILE__) + '/../../unit_test_helper')

class CreateMissingLoginAccessForUsersTest < ActiveSupport::TestCase

  def setup
    login_as_admin
    @project = create_project
    @project.activate
  end

  def test_applying_fix_will_create_missing_login_access_record
    victim = create_user!
    assert_false DataFixes::CreateMissingLoginAccessForUsers.required?
    victim.login_access.destroy
    assert_nil victim.reload.login_access
    assert DataFixes::CreateMissingLoginAccessForUsers.required?

    DataFixes::CreateMissingLoginAccessForUsers.apply
    assert_not_nil victim.reload.login_access
    assert_false DataFixes::CreateMissingLoginAccessForUsers.required?
  ensure
    victim.destroy
  end

end
