require 'test_helper'

class ClassroomActivityPairingTest < ActiveSupport::TestCase

  test "ClassroomActivityPairing.from_hash" do

    sql = "select * from classroom_activity_pairings where id = " + classroom_activity_pairings(:c1s_to_a1s).id.to_s
    arguments = [sql]
    sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, arguments)
    activities = ActiveRecord::Base.connection.execute(sanitized_query).to_a
    
    b = ClassroomActivityPairing.from_hash(activities[0])
    a = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a1s).id.to_s)

    assert_equal a,b, "ClassroomActivityPairing.from_hash not creating accurate ClassroomActivityPairing object from hash"

  end

  test "attributes_eql?" do 

		sql = "select * from classroom_activity_pairings where id = " + classroom_activity_pairings(:c1s_to_a1s).id.to_s
		arguments = [sql]
		sanitized_query = ActiveRecord::Base.send(:sanitize_sql_array, arguments)
		activities = ActiveRecord::Base.connection.execute(sanitized_query).to_a

		b = ClassroomActivityPairing.from_hash(activities[0])
		a = ClassroomActivityPairing.find(classroom_activity_pairings(:c1s_to_a1s).id.to_s)

		assert_equal a,b, "ClassroomActivityPairing.from_hash not creating accurate ClassroomActivityPairing object from hash"

		b.created_at = nil
		b.updated_at = nil

		assert a.attributes_eql?(b), "ClassroomActivityPairing.eql_no_timestamps returned false with everything (except timestamps) equal"

	end 
end
