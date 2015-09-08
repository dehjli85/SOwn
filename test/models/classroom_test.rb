require 'test_helper'

class ClassroomTest < ActiveSupport::TestCase
  
  test "teacher_user_id, name, and classroom_code present" do
    	
    c1 = Classroom.new
    assert_not c1.save, "saved without classroom_code, name, teacher_user_id"

    c1.name = "new test classroom"
    assert_not c1.save, "saved without classroom_code, teacher_user_id"

    c1.teacher_user_id = 1
    assert_not c1.save, "saved without classroom_code"

    

  end

  test "classroom_code is unique" do
    c1 = Classroom.new
		c1.name = "test1"
	    c1.teacher_user_id = 1
    c1.classroom_code = "test1"
    assert_not c1.save, "saved with duplicate classroom_code"

  end
  
  test "classroom_code less than 100" do
		c1 = Classroom.new
		c1.name = "test1"
    c1.teacher_user_id = 1
    c1.classroom_code = "test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1a"
    assert_not c1.save, "saved with classroom code greater than size limit"  	
  end

  test "classroom_code in valid format" do
		c1 = Classroom.new
		c1.name = "test1"
    c1.teacher_user_id = 1
    c1.classroom_code = "test 1"
    assert_not c1.save, "saved with space in classroom_code"  	

    c1.classroom_code = "test$1"
    assert_not c1.save, "saved with special character in classroom_code"  	

    c1.classroom_code = "test-1"
    assert c1.save, "failed to save with valid classroom_code containing dash"

    c1.classroom_code = "test-1-2"
    assert c1.save, "failed to save with valid classroom_code containing multiple dashes"

  end


  test "tags" do 
    c = classrooms(:c1s)
    t1 = activity_tags(:t1)
    t2 = activity_tags(:t2)

    expected_tags = [t1, t2]
    outputed_tags = c.tags

    assert_equal expected_tags, outputed_tags, "tags did not return the expected tags for classroom c1s"

    c = classrooms(:c1g)
    t3 = activity_tags(:t3)
    t4 = activity_tags(:t4)

    expected_tags = [t3, t4]
    outputed_tags = c.tags

    assert_equal expected_tags, outputed_tags, "tags did not return the expected tags for classroom c1g"

    c = classrooms(:c2g)
    t3 = activity_tags(:t3)

    expected_tags = [t3]
    outputed_tags = c.tags(false)

    assert_equal expected_tags, outputed_tags, "tags did not return the expected tags for classroom c2g excluding hidden activities"

  end

  test "search_matched_pairings no search" do 
    c = classrooms(:c1s)
    c1s_to_a1s = classroom_activity_pairings(:c1s_to_a1s)
    c1s_to_a2s = classroom_activity_pairings(:c1s_to_a2s)
    c1s_to_a3s = classroom_activity_pairings(:c1s_to_a3s)
    c1s_to_a5s = classroom_activity_pairings(:c1s_to_a5s)

    expected_tags = [c1s_to_a2s, c1s_to_a1s, c1s_to_a5s, c1s_to_a3s]
    outputed_tags = c.search_matched_pairings

    assert_equal expected_tags, outputed_tags, "search_matched_pairings did not return the expected Classroom Activity Pairings for Classroom c1s when called with no search term"

  end

  test "search_matched_pairings with matching tag name" do 
    c = classrooms(:c1s)
    c1s_to_a1s = classroom_activity_pairings(:c1s_to_a1s)
    c1s_to_a2s = classroom_activity_pairings(:c1s_to_a2s)

    expected_tags = [c1s_to_a2s, c1s_to_a1s]
    outputed_tags = c.search_matched_pairings({search_tag: activity_tags(:t1).name})

    assert_equal expected_tags, outputed_tags, "search_matched_pairings did not return the expected Classroom Activity Pairings for Classroom c1s when called with name for Activity Tag t1"

  end

  test "search_matched_pairings with non-matching tag name" do 
    c = classrooms(:c1s)

    outputed_tags = c.search_matched_pairings({search_tag: activity_tags(:t4).name})

    assert_empty outputed_tags, "search_matched_pairings returned non-empty array when called for Classroom c1s when called with name for Activity Tag t4"

  end

  test "search_matched_pairings with general search term 'tag1" do 
    c = classrooms(:c1s)

    c1s_to_a1s = classroom_activity_pairings(:c1s_to_a1s)
    c1s_to_a2s = classroom_activity_pairings(:c1s_to_a2s)

    expected_tags = [c1s_to_a2s, c1s_to_a1s]
    outputed_tags = c.search_matched_pairings({search_term: 'tag1'})

    assert_equal expected_tags, outputed_tags, "search_matched_pairings did not return the expected Classroom Activity Pairings for Classroom c1s when called with name for Activity Tag t1"

  end

  test "search_matched_pairings with general search term 'tag1 and tag name" do 
    c = classrooms(:c1s)

    c1s_to_a1s = classroom_activity_pairings(:c1s_to_a1s)
    c1s_to_a2s = classroom_activity_pairings(:c1s_to_a2s)

    expected_tags = [c1s_to_a2s, c1s_to_a1s]
    outputed_tags = c.search_matched_pairings({search_term: 'tag1', search_tag: activity_tags(:t1).name})

    assert_equal expected_tags, outputed_tags, "search_matched_pairings did not return the expected Classroom Activity Pairings for Classroom c1s when called with name for Activity Tag t1"

  end



end
