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

require File.expand_path(File.dirname(__FILE__) + '/../unit_test_helper')

#Tags:
class GroupTest < ActiveSupport::TestCase

  def setup
    @project = first_project
    @project.activate
    @member = User.find_by_login("member")
  end

  def test_must_have_name
    assert_false @project.groups.new(:name => '').valid?
  end

  def test_group_name_should_be_uniq_in_project
    create_group('group')
    assert_false @project.groups.new(:name => 'group').valid?
  end

  def test_group_name_should_be_case_insensitive
    create_group('Group')
    assert_false @project.groups.new(:name => 'group').valid?
  end

  def test_group_name_should_be_space_insensitive
    create_group('Group')
    assert_false @project.groups.new(:name => ' Group').valid?
  end

  def test_group_name_could_not_be_longer_than_255_chars
    name = 'g'
    255.times { name += '1'}
    assert_false @project.groups.create(:name => name).valid?
  end

  def test_should_be_able_to_have_same_group_name_on_different_projects
    with_new_project do |project|
      project.groups.create!(:name => 'Group')
    end
    with_new_project do |project|
      assert_difference "Group.count" do
        project.groups.create!(:name => 'Group')
      end
    end
  end

  def test_should_delete_group_membership_when_delete_a_group
    group = create_group('group')
    group.add_member(@member)
    assert_equal 1, group.reload.users.count
    group.destroy
    group = create_group('group')
    assert_equal 0, group.users.count
  end

  def test_group_name_with_comma_gets_error_message
    group = @project.groups.new(:name => 'mana, bananna')
    assert_false group.valid?
    assert_equal "Name cannot contain comma.", group.errors.full_messages.join('')
  end

  def test_save_blank_name_should_not_contain_other_error_message
    group = create_group 'seat'
    group.name = ''
    assert_false group.valid?
    assert_equal "Name cannot be blank.", group.errors.full_messages.join('')
  end

  def test_group_name_should_be_unique
    create_group "MANA"
    group = create_group "will change to MANA"
    group.name = "MANA"
    assert_false group.valid?
    assert_equal "Name has already been taken", group.errors.full_messages.join('')
  end

  def test_remove_member
    group = create_group('group')
    group.add_member(@member)
    assert group.member?(@member)

    group.remove_member(@member)
    assert_false group.member?(@member)
  end

  def test_add_members
    group = create_group('group')
    group.add_member(@member)
    assert group.member?(@member)
  end

  def test_add_members_should_not_create_duplicates_when_adding_a_projects_member_to_group_multiple_times
    group = create_group('group')

    group.add_member @member
    group.add_member @member

    assert group.member?(@member)
    assert_equal 1, group.user_memberships.count
  end

  def test_delete_group_should_remove_all_projects_members
    group = create_group('group')
    group.add_member(@member)
    assert_difference "UserMembership.count", -1 do
      group.destroy
    end
  end

  def test_mingle_admin_can_add_members_to_group
    group = create_group('group')
    assert_nothing_raised { group.add_member(@member) }
  end
end
