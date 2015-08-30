require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  test "activities_with_pairing_ids invalid classroomsId" do
    
    activities_with_pairings = Activity.activities_with_pairings_ids(-1)
    
    assert_nil activities_with_pairings, "non nil value returned with invalid classroomId"

    activities_with_pairings = Activity.activities_with_pairings_ids(nil)

    assert_nil activities_with_pairings, "non nil value returned with invalid classroomId"


  end

  test "activities_with_pairing_ids method no search" do
    
    activities_with_pairings = Activity.activities_with_pairings_ids(classrooms(:c1s))
    activities_array = activities_with_pairings.as_json
    
    assert_not_empty 	activities_array

    includes_a1s = false
    includes_a2s = false
    includes_a3s = false    
    includes_c1s_to_a1s = false
    includes_c1s_to_a2s = false
    includes_c1s_to_a3s = false


    activities_array.each do |activity_hash|
    	
    	if activity_hash["id"].to_i.eql?(activities(:a1s).id)
    		includes_a1s = true
    	elsif activity_hash["id"].to_i.eql?(activities(:a2s).id)
    		includes_a2s = true
  		elsif activity_hash["id"].to_i.eql?(activities(:a3s).id)
    		includes_a3s = true
    	end

			if activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a1s).id)
    		includes_c1s_to_a1s = true
    	elsif activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a2s).id)
    		includes_c1s_to_a2s = true
    	elsif activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a3s).id)
    		includes_c1s_to_a3s = true
    	end

    end

    assert includes_a1s, "activities_with_pairings_ids(c1s.id) did not return a1s"
    assert includes_a2s, "activities_with_pairings_ids(c1s.id) did not return a2s"
    assert includes_a3s, "activities_with_pairings_ids(c1s.id) did not return a3s"
    assert includes_c1s_to_a1s, "activities_with_pairings_ids(c1s.id) did not return c1s_to_a1s"
    assert includes_c1s_to_a2s, "activities_with_pairings_ids(c1s.id) did not return c1s_to_a2s"
    assert includes_c1s_to_a3s, "activities_with_pairings_ids(c1s.id) did not return c1s_to_a3s"


  end

  test "activities_with_pairing_ids with matching tagId" do
    
    activities_with_pairings = Activity.activities_with_pairings_ids(classrooms(:c1s), nil, activity_tags(:t1))
    activities_array = activities_with_pairings.as_json
    
    assert_not_empty 	activities_array

    includes_a1s = false
    includes_a2s = false
    includes_a3s = false    
    includes_c1s_to_a1s = false
    includes_c1s_to_a2s = false
    includes_c1s_to_a3s = false

    activities_array.each do |activity_hash|
    	
    	if activity_hash["id"].to_i.eql?(activities(:a1s).id)
    		includes_a1s = true
    	elsif activity_hash["id"].to_i.eql?(activities(:a2s).id)
    		includes_a2s = true
  		elsif activity_hash["id"].to_i.eql?(activities(:a3s).id)
    		includes_a3s = true
    	end

			if activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a1s).id)
    		includes_c1s_to_a1s = true
    	elsif activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a2s).id)
    		includes_c1s_to_a2s = true
    	elsif activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a3s).id)
    		includes_c1s_to_a3s = true
    	end

    end

    assert includes_a1s, "activities_with_pairings_ids(c1s.id, nil, t1.id) did not return a1s"
    assert includes_a2s, "activities_with_pairings_ids(c1s.id, nil, t1.id) did not return a2s"
    assert_not includes_a3s, "activities_with_pairings_ids(c1s.id, nil, t1.id) did not returned a3d"
    assert includes_c1s_to_a1s, "activities_with_pairings_ids(c1s.id, nil, t1.id) did not return c1s_to_a1s"
    assert includes_c1s_to_a2s, "activities_with_pairings_ids(c1s.id, nil, t1.id) did not return c1s_to_a2s"
    assert_not includes_c1s_to_a3s, "activities_with_pairings_ids(c1s.id, nil, t1.id) did not return c1s_to_a3s"


  end

  test "activities_with_pairing_ids with non-matching tagId" do
    
    activities_with_pairings = Activity.activities_with_pairings_ids(classrooms(:c1s), nil, activity_tags(:t3))
    activities_array = activities_with_pairings.as_json
    
    assert_empty 	activities_array, "activities_with_pairings_ids(c1s.id, nil, t3.id) returned a non-empty result"
    
  end

  test "activities_with_pairing_ids with general search term 'tag1'" do
    
    activities_with_pairings = Activity.activities_with_pairings_ids(classrooms(:c1s), "tag1", nil)
    activities_array = activities_with_pairings.as_json
    
    assert_not_empty 	activities_array

    includes_a1s = false
    includes_a2s = false
    includes_a3s = false    
    includes_c1s_to_a1s = false
    includes_c1s_to_a2s = false
    includes_c1s_to_a3s = false

    activities_array.each do |activity_hash|
    	
    	if activity_hash["id"].to_i.eql?(activities(:a1s).id)
    		includes_a1s = true
    	elsif activity_hash["id"].to_i.eql?(activities(:a2s).id)
    		includes_a2s = true
  		elsif activity_hash["id"].to_i.eql?(activities(:a3s).id)
    		includes_a3s = true
    	end

			if activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a1s).id)
    		includes_c1s_to_a1s = true
    	elsif activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a2s).id)
    		includes_c1s_to_a2s = true
    	elsif activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a3s).id)
    		includes_c1s_to_a3s = true
    	end

    end

    assert includes_a1s, "activities_with_pairings_ids(c1s.id, 'tag1') did not return a1s"
    assert includes_a2s, "activities_with_pairings_ids(c1s.id, 'tag1') did not return a2s"
    assert_not includes_a3s, "activities_with_pairings_ids(c1s.id, 'tag1') returned a3s"
    assert includes_c1s_to_a1s, "activities_with_pairings_ids(c1s.id, 'tag1') did not return c1s_to_a1s"
    assert includes_c1s_to_a2s, "activities_with_pairings_ids(c1s.id, 'tag1') did not return c1s_to_a2s"
    assert_not includes_c1s_to_a3s, "activities_with_pairings_ids(c1s.id, 'tag1') returned c1s_to_a3s"

  end

  test "activities_with_pairing_ids with general search term 'tag1' and tagId" do
    
    activities_with_pairings = Activity.activities_with_pairings_ids(classrooms(:c1s), "tag1", activity_tags(:t1))

    activities_array = activities_with_pairings.as_json
    
    assert_not_empty    activities_array

    includes_a1s = false
    includes_a2s = false
    includes_a3s = false    
    includes_c1s_to_a1s = false
    includes_c1s_to_a2s = false
    includes_c1s_to_a3s = false

    activities_array.each do |activity_hash|
        
        if activity_hash["id"].to_i.eql?(activities(:a1s).id)
            includes_a1s = true
        elsif activity_hash["id"].to_i.eql?(activities(:a2s).id)
            includes_a2s = true
        elsif activity_hash["id"].to_i.eql?(activities(:a3s).id)
            includes_a3s = true
        end

            if activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a1s).id)
            includes_c1s_to_a1s = true
        elsif activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a2s).id)
            includes_c1s_to_a2s = true
        elsif activity_hash["classroom_activity_pairing_id"].to_i.eql?(classroom_activity_pairings(:c1s_to_a3s).id)
            includes_c1s_to_a3s = true
        end

    end

    assert includes_a1s, "activities_with_pairings_ids(c1s.id, 'tag1') did not return a1s"
    assert includes_a2s, "activities_with_pairings_ids(c1s.id, 'tag1') did not return a2s"
    assert_not includes_a3s, "activities_with_pairings_ids(c1s.id, 'tag1') returned a3s"
    assert includes_c1s_to_a1s, "activities_with_pairings_ids(c1s.id, 'tag1') did not return c1s_to_a1s"
    assert includes_c1s_to_a2s, "activities_with_pairings_ids(c1s.id, 'tag1') did not return c1s_to_a2s"
    assert_not includes_c1s_to_a3s, "activities_with_pairings_ids(c1s.id, 'tag1') returned c1s_to_a3s"

  end

end
