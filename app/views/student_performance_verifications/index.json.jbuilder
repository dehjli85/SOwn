json.array!(@student_performance_verifications) do |student_performance_verification|
  json.extract! student_performance_verification, :id, :classroom_activity_pairing_id, :student_user_id
  json.url student_performance_verification_url(student_performance_verification, format: :json)
end
