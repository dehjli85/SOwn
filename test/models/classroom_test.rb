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

  test "search_matched_pairings_and_activities" do

	  c1s = classrooms(:c1s)
	  asp = c1s.search_matched_pairings_and_activities

	  assert_not_empty(asp[:activities], "c1s.search_matched_pairings_and_activities activities is empty")

	  assert asp[:activities].include?(activities(:a1s)), "activities from c1s.search_matched_pairings_and_activities did not include a1s"
	  assert asp[:activities].include?(activities(:a2s)), "activities from c1s.search_matched_pairings_and_activities did not include a2s"
	end


end
