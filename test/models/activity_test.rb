require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  test "save activity activity_type validation" do
    
    a = Activity.new

    a.activity_type = "percentage"
    a.teacher_user_id = teacher_users(:demo_standard).id
    a.name = "test activity"

    assert_not a.save, "activity saved with bad activity_type"

    a.activity_type = "completion"
    assert a.save, "activity not saved with valid activity_type"

    a.activity_type = "scored"
    assert a.save, "activity not saved with valid activity_type"

  end

  test "save activity name, activity_type, teacher_user_id presence validation" do
    
    a = Activity.new
    a.teacher_user_id = teacher_users(:demo_standard).id
    a.activity_type = "completion"
    a.name = "test activity"

    assert a.save, "activity not saved with valid name, activity_type, and teacher_user_id"

    a.activity_type = nil
    assert_not a.save, "activity saved without activity_type"

    a.activity_type = "completion"
    a.teacher_user_id = nil
    assert_not a.save, "activity saved without teacher_user_id"

    a.teacher_user_id = teacher_users(:demo_standard).id
    a.name = nil    
    assert_not a.save, "activity saved without name"

  end

  test "min_score, max_score, benchmark1_score, benchmark2_score numericality validation" do 

    a = Activity.new
    a.teacher_user_id = teacher_users(:demo_standard).id
    a.activity_type = "completion"
    a.name = "test activity"
    assert a.save, "activity not saved with valid name, activity_type, and teacher_user_id"


    a.min_score = 0
    assert a.save, "activity not saved with valid min_score"

    a.max_score = 100
    assert a.save, "activity not saved with valid max_score"

    a.min_score = "s"
    assert_not a.save, "activity saved with non-numeric min_score"
    a.min_score = 0 

    a.max_score = 'asdfasd'
    assert_not a.save, "activity saved with non-numeric max_score"
    a.max_score = 100

    a.benchmark1_score = 12.5
    assert a.save, "activity not saved with valid benchmark1_score"

    a.benchmark2_score = 80.5
    assert a.save, "activity not saved with valid benchmark2_score"

    a.benchmark1_score = 'asdfasd'
    assert_not a.save, "activity saved with non-numeric benchmark1_score"
    a.benchmark1_score = 12.5

    a.benchmark2_score = 'asdfasd'
    assert_not a.save, "activity saved with non-numeric benchmark2_score"
    a.benchmark2_score = 80.5

  end

  test "min_less_than_max validation" do 

    a = Activity.new
    a.teacher_user_id = teacher_users(:demo_standard).id
    a.activity_type = "completion"
    a.name = "test activity"
    assert a.save, "activity not saved with valid name, activity_type, and teacher_user_id"

    a.min_score = 0
    a.max_score = 100

    assert a.save, "activity not saved with valid min_score and max_score"

    a.min_score = 101
    assert_not a.save, "activity saved with min_score > max_score"

    a.min_score = 100
    assert_not a.save, "activity saved with min_score = max_score"


  end

  test "benchmarks_valid validation" do
    a = Activity.new
    a.teacher_user_id = teacher_users(:demo_standard).id
    a.activity_type = "completion"
    a.name = "test activity"
    assert a.save, "activity not saved with valid name, activity_type, and teacher_user_id"

    a.min_score = 0
    a.benchmark1_score = 50
    a.benchmark2_score = 75
    a.max_score = 100

    assert a.save, "activity not saved with valid benchmarks"

    a.benchmark1_score = nil
    assert a.save, "activity not saved with valid benchmark2"
    a.benchmark1_score = 50

    a.benchmark2_score = nil
    assert a.save, "activity not saved with valid benchmark1"
    a.benchmark2_score = 75

    a.min_score = nil
    assert_not a.save, "activity saved with benchmarks, but no min_score"
    a.min_score = 0

    a.max_score = nil
    assert_not a.save, "activity saved with benchmarks, but no max_score"
    a.max_score = 100

    a.benchmark1_score = 0
    assert a.save, "activity not saved with benchmarks1 = min_score"

    a.benchmark1_score = -2
    assert_not a.save, "activity saved with benchmarks1 < min_score"

    a.benchmark2_score = nil
    a.benchmark1_score = 100
    assert a.save, "activity not saved with benchmarks1 = max_score"
    a.benchmark2_score = 75

    a.benchmark1_score = 150
    assert_not a.save, "activity saved with benchmarks1 > max_score"
    a.benchmark1_score = 50

    a.benchmark2_score = 0
    assert_not a.save, "activity saved with benchmarks2 = min_score"

    a.benchmark2_score = -2
    assert_not a.save, "activity saved with benchmarks2 < min_score"

    a.benchmark2_score = 100
    assert a.save, "activity saved with benchmarks2 = max_score"

    a.benchmark2_score = 150
    assert_not a.save, "activity saved with benchmarks2 > max_score"

    a.benchmark2_score = 50
    assert_not a.save, "activity saved with benchmarks2 = benchmark1_score"

    a.benchmark2_score = 25
    assert_not a.save, "activity saved with benchmarks2 < benchmark1_score"


  end

  test "set_pretty_properties" do

    a = Activity.new
    a.teacher_user_id = teacher_users(:demo_standard).id
    a.activity_type = "completion"
    a.name = "test activity"
    a.description = "123456789012345678901234567890"
    a.instructions = "123456789012345678901234567890"
    assert a.save, "activity not saved with valid name, activity_type, and teacher_user_id"


    a.set_pretty_properties
    assert a.activity_type_pretty.eql?("Completion"), "activity_type pretty did not match expected output for completion activity"
    assert a.description_abbreviated.eql?("12345678901234567890123456..."), "description_abbreviated did not match expected abbreviation"
    assert a.instructions_abbreviated.eql?("12345678901234567890123456..."), "instructions_abbreviated did not match expected abbreviation"

    a.activity_type = "scored"
    a.set_pretty_properties
    assert a.activity_type_pretty.eql?("Scored"), "activity_type pretty did not match expected output for scored activity"

    activity_id = a.id

    b = Activity.find(activity_id)
    assert_equal a,b, "cannot find saved activity"
    assert a.activity_type_pretty.eql?("Scored"), "activity_type_pretty not loaded after Activity.find"
    assert a.description_abbreviated.eql?("12345678901234567890123456..."), "description_abbreviated not loaded after Activity.find"
    assert a.instructions_abbreviated.eql?("12345678901234567890123456..."), "instructions_abbreviated not loaded after Activity.find"



  end 

  test "Activity.from_hash" do

    sql = "select * from activities where id = " + activities(:a1s).id.to_s
    arguments = [sql]
    sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, arguments)
    activities = ActiveRecord::Base.connection.execute(sanitized_query).to_a
    
    b = Activity.from_hash(activities[0])
    a = Activity.find(activities(:a1s).id)

    assert_equal a,b, "Activity.from_hash not creating accurate Activity object from hash"

  end
  
  test "activities_with_pairings invalid classroomsId" do
    
    activities_with_pairings = Activity.activities_with_pairings(-1)
    
    assert_nil activities_with_pairings, "non nil value returned with invalid classroomId"

    activities_with_pairings = Activity.activities_with_pairings(nil)

    assert_nil activities_with_pairings, "non nil value returned with invalid classroomId"


  end

  test "activities_with_pairings method no search" do
    
    activities_with_pairings = Activity.activities_with_pairings(classrooms(:c1s))
    # activities_array = activities_with_pairings.as_json

    a1s = Activity.find(activities(:a1s))
    a2s = Activity.find(activities(:a2s))
    a3s = Activity.find(activities(:a3s))
    a5s = Activity.find(activities(:a5s))

    c1s_to_a1s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a1s))
    c1s_to_a2s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a2s))
    c1s_to_a3s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a3s))
    c1s_to_a5s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a5s))

    
    expected_activities = [a2s, a1s, a5s, a3s]
    expected_classroom_activity_pairings = [c1s_to_a2s, c1s_to_a1s, c1s_to_a5s, c1s_to_a3s]

    output_activities = []
    output_classroom_activity_pairings = []
    activities_with_pairings.each do |activity|
        output_activities.push(Activity.from_hash(activity))
        activity["id"] = activity["classroom_activity_pairing_id"]
        output_classroom_activity_pairings.push(ClassroomActivityPairing.from_hash(activity))

    end

    assert_equal expected_activities, output_activities, "outputed activities do not match expected output"
    assert_equal expected_classroom_activity_pairings, output_classroom_activity_pairings, "outputed classroom_activity_pairings do not match expected output"

  end

  test "activities_with_pairings with matching tagId" do
    
    activities_with_pairings = Activity.activities_with_pairings(classrooms(:c1s), nil, activity_tags(:t1))

    a1s = Activity.find(activities(:a1s))
    a2s = Activity.find(activities(:a2s))

    c1s_to_a1s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a1s))
    c1s_to_a2s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a2s))

    
    expected_activities = [a2s, a1s]
    expected_classroom_activity_pairings = [c1s_to_a2s, c1s_to_a1s]

    output_activities = []
    output_classroom_activity_pairings = []
    activities_with_pairings.each do |activity|
        output_activities.push(Activity.from_hash(activity))
        activity["id"] = activity["classroom_activity_pairing_id"]
        output_classroom_activity_pairings.push(ClassroomActivityPairing.from_hash(activity))

    end

    assert_equal expected_activities, output_activities, "outputed activities do not match expected output"
    assert_equal expected_classroom_activity_pairings, output_classroom_activity_pairings, "outputed classroom_activity_pairings do not match expected output"


  end

  test "activities_with_pairings with non-matching tagId" do
    
    activities_with_pairings = Activity.activities_with_pairings(classrooms(:c1s), nil, activity_tags(:t3))
    activities_array = activities_with_pairings.as_json
    
    assert_empty 	activities_array, "activities_with_pairings_ids(c1s.id, nil, t3.id) returned a non-empty result"
    
  end

  test "activities_with_pairings with general search term 'tag1'" do
    
    activities_with_pairings = Activity.activities_with_pairings(classrooms(:c1s), "tag1", nil)
    a1s = Activity.find(activities(:a1s))
    a2s = Activity.find(activities(:a2s))

    c1s_to_a1s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a1s))
    c1s_to_a2s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a2s))

    
    expected_activities = [a2s, a1s]
    expected_classroom_activity_pairings = [c1s_to_a2s, c1s_to_a1s]

    output_activities = []
    output_classroom_activity_pairings = []
    activities_with_pairings.each do |activity|
        output_activities.push(Activity.from_hash(activity))
        activity["id"] = activity["classroom_activity_pairing_id"]
        output_classroom_activity_pairings.push(ClassroomActivityPairing.from_hash(activity))

    end

    assert_equal expected_activities, output_activities, "outputed activities do not match expected output"
    assert_equal expected_classroom_activity_pairings, output_classroom_activity_pairings, "outputed classroom_activity_pairings do not match expected output"


  end

  test "activities_with_pairings with general search term 'tag1' and tagId" do
    
    activities_with_pairings = Activity.activities_with_pairings(classrooms(:c1s), "tag1", activity_tags(:t1))

    a1s = Activity.find(activities(:a1s))
    a2s = Activity.find(activities(:a2s))

    c1s_to_a1s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a1s))
    c1s_to_a2s = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a2s))

    
    expected_activities = [a2s, a1s]
    expected_classroom_activity_pairings = [c1s_to_a2s, c1s_to_a1s]

    output_activities = []
    output_classroom_activity_pairings = []
    activities_with_pairings.each do |activity|
        output_activities.push(Activity.from_hash(activity))
        activity["id"] = activity["classroom_activity_pairing_id"]
        output_classroom_activity_pairings.push(ClassroomActivityPairing.from_hash(activity))

    end

    assert_equal expected_activities, output_activities, "outputed activities do not match expected output"
    assert_equal expected_classroom_activity_pairings, output_classroom_activity_pairings, "outputed classroom_activity_pairings do not match expected output"

  end

end
