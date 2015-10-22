require 'test_helper'

class ActivityTagTest < ActiveSupport::TestCase

	##################################################################################################
  #
  # Validations
  #
  ##################################################################################################

	test "save activity tag validation" do
    
    t = ActivityTag.new

    t.name = ""

    assert_not t.save, "activity tag saved with empty name"

    t.name = "tag with spaces"
    assert_not t.save, "activity tag not saved with spaces in name"

    t.name = "testTag"
    assert t.save, "activity tag not saved with valid name"

    t2 = ActivityTag.new
    t2.name = "testTag"
    assert_not t2.save, "duplicate activity tag saved"

  end

  ##################################################################################################
  #
  # Model API Methods
  #
  ##################################################################################################

  test "name setting and retrieving" do

	  t2 = ActivityTag.new
    t2.name = "#hello"
    assert_equal t2.name, "hello"

    assert_equal t2.hashed_name , '#hello'
  
  end

  test 'tags_for_teacher' do

    tags = ActivityTag.tags_for_teacher(teacher_users(:demo_standard).id)

    t1 = ActivityTag.find(activity_tags(:t1).id)
    t2 = ActivityTag.find(activity_tags(:t2).id)

    expected_output = [t1, t2]
    assert_equal expected_output, tags

    tags = ActivityTag.tags_for_teacher(teacher_users(:demo_gmail).id)
		
		t3 = ActivityTag.find(activity_tags(:t3).id)
    t4 = ActivityTag.find(activity_tags(:t4).id)

    expected_output = [t3, t4]
    assert_equal expected_output, tags

	end


end
