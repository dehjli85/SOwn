require 'test_helper'

class TeacherAccountControllerTest < ActionController::TestCase
  
  test "index action" do

  	get :index, {}, {}
		assert_response :redirect
		assert_redirected_to "/#login"

		get :index, {}, {teacher_user_id: -1}
		assert_response :redirect
		assert_redirected_to "/#login"

  	get :index, {}, {teacher_user_id: teacher_users(:demo_standard).id}
    assert_response :success

  end


  test "delete_account action" do

    post :delete_account, {}, {}
    assert_response :success
    assert_equal '{"status":"error","message":"user-not-logged-in"}', @response.body
    
    post :delete_account, {teacher_user_id: teacher_users(:demo_standard).id+1}, {teacher_user_id: teacher_users(:demo_standard).id}
    assert_response :success
    assert_equal '{"status":"error","message":"user-not-logged-in"}', @response.body

    post :delete_account, {teacher_user_id: teacher_users(:demo_standard).id+1}, {}
    assert_response :success
    assert_equal '{"status":"error","message":"user-not-logged-in"}', @response.body

    post :delete_account, {}, {teacher_user_id: teacher_users(:demo_standard).id}
    assert_response :success
    assert_equal '{"status":"error","message":"user-not-logged-in"}', @response.body

    id = teacher_users(:demo_standard).id
    post :delete_account, {teacher_user_id: teacher_users(:demo_standard).id}, {teacher_user_id: teacher_users(:demo_standard).id}
    assert_response :success
    assert_equal '{"status":"success"}', @response.body
    assert_equal TeacherUser.find(id).email, "sowntogrow_deleted_teacher_" + id.to_s + "@sowntogrow.com"
    assert_nil session["teacher_user_id"]
    assert_nil session["student_user_id"]


  end

end
