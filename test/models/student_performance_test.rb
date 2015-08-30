require 'test_helper'

class StudentPerformanceTest < ActiveSupport::TestCase


	##################################################################################################
  #
  # Validations
  #
  ##################################################################################################

  test "student_user_id, classroom_activity_pairing_id, performance_date present" do
    
    # Test saving a scored performance
    sp_scored = StudentPerformance.new
    sp_scored.scored_performance = "50"

    assert_not sp_scored.save, "saved without student_user_id, classroom_activity_pairing_id, performance_date "

    sp_scored.student_user_id = student_users(:s1).id
    assert_not sp_scored.save, "saved without classroom_activity_pairing_id, performance_date "

    sp_scored.classroom_activity_pairing_id = classroom_activity_pairings(:c1s_to_a1s).id
    assert_not sp_scored.save, "saved without performance_date "

    sp_scored.performance_date = Date.new
    assert sp_scored.save, "not saved with valid scored_performance"

    # Test saving a completion performance
    sp_completion = StudentPerformance.new
    sp_completion.completed_performance = true
    
    assert_not sp_completion.save, "saved without student_user_id, classroom_activity_pairing_id, performance_date "

    sp_completion.student_user_id = student_users(:s1).id
    assert_not sp_completion.save, "saved without classroom_activity_pairing_id, performance_date "

    sp_completion.classroom_activity_pairing_id = classroom_activity_pairings(:c1s_to_a5s).id
    assert_not sp_completion.save, "saved without performance_date "
    
    sp_completion.performance_date = Date.new
    assert sp_completion.save, "not saved with valid completed_performance"

    sp_completion.completed_performance = nil
    assert_not sp_completion.save, "saved with nil completed_performance"

  end

  test "scored_performance is numeric" do
    
    sp1 = StudentPerformance.new
    sp1.student_user_id = student_users(:s1).id
    sp1.classroom_activity_pairing_id = classroom_activity_pairings(:c1s_to_a1s).id
    sp1.performance_date = Date.new

    sp1.scored_performance = "hello"
    assert_not sp1.save, "StudentPerformance saved with non-numeric scored_performance ('hello')"

    sp1.scored_performance = "50"
    assert sp1.save, "StudentPerformance not saved with numeric scored_performance ('-1')"

  end
  
  test "scored_performance within range" do

		sp1 = StudentPerformance.new
    sp1.student_user_id = student_users(:s1).id
    sp1.classroom_activity_pairing_id = classroom_activity_pairings(:c1s_to_a1s).id
    sp1.performance_date = Date.new

    sp1.scored_performance = -1
    assert_not sp1.save, "StudentPerformance saved with out of range value (-1), range: [0,100]"

    sp1.scored_performance = 101
    assert_not sp1.save, "StudentPerformance saved with out of range value (101), range: [0,100]"

		sp1.scored_performance = 50
    assert sp1.save, "StudentPerformance not saved value in range (50), range: [0,100]"



  end

  test "student_user exists" do
		sp1 = StudentPerformance.new
    sp1.student_user_id = -10
    sp1.classroom_activity_pairing_id = classroom_activity_pairings(:c1s_to_a1s).id
    sp1.performance_date = Date.new

    sp1.scored_performance = 10
    assert_not sp1.save, "StudentPerformance saved with invalid student_user_id"

  end

  test "classroom_activity_pairing_id exists" do
		sp1 = StudentPerformance.new
    sp1.student_user_id = classroom_student_users(:s1_to_c1s).id
    sp1.classroom_activity_pairing_id = -10
    sp1.performance_date = Date.new

    sp1.scored_performance = 10
    assert_not sp1.save, "StudentPerformance saved with invalid classroom_activity_pairing_id"

  end


  ##################################################################################################
  #
  # Model API Methods
  #
  ##################################################################################################

  test "activity method" do

  	sp_completion = StudentPerformance.new
    sp_completion.completed_performance = true
    sp_completion.student_user_id = student_users(:s1).id
    sp_completion.classroom_activity_pairing_id = classroom_activity_pairings(:c1s_to_a5s).id
    sp_completion.performance_date = Date.new

    assert_equal(sp_completion.activity, activities(:a5s))

    sp_completion.classroom_activity_pairing_id = -1
    assert_nil sp_completion.activity


  end

  test "activity type method" do

  	sp_completion = StudentPerformance.new
    sp_completion.completed_performance = true
    sp_completion.student_user_id = student_users(:s1).id
    sp_completion.classroom_activity_pairing_id = classroom_activity_pairings(:c1s_to_a5s).id
    sp_completion.performance_date = Date.new

    assert_equal(sp_completion.activity_type, activities(:a5s).activity_type)

    sp_completion.classroom_activity_pairing_id = -1
    assert_nil sp_completion.activity_type


  end

end
