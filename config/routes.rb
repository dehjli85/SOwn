Rails.application.routes.draw do



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # application routes
  get 'current_user' => 'application#current_user_json'

  # public pages routes  
  post 'login_post' => 'public_pages#login_post'
  post 'teacher_google_sign_up' => 'public_pages#teacher_google_sign_up'
  post 'student_google_sign_up' => 'public_pages#student_google_sign_up'
  post 'google_login_post' => 'public_pages#google_login_post'
  post 'teacher_sign_up' => 'public_pages#teacher_sign_up'
  post 'student_sign_up' => 'public_pages#student_sign_up'
  
  get 'auth/:provider/callback', to: 'public_pages#google_auth_callback'
  get 'signout', to: 'public_pages#signout', as: 'signout'
  get 'auth/failure', to: redirect('/')

  get 'privacy' => 'public_pages#privacy'
  get 'terms_of_service' => 'public_pages#terms_of_service'
  
  # teacher routes
  get 'teacher_home' => 'teacher_account#index'
  post 'teacher/update_classroom' => 'teacher_account#update_classroom'
  post 'teacher/save_new_classroom' => 'teacher_account#save_new_classroom'

  # teacher/settings routes
  post 'teacher/delete_account' => 'teacher_account#delete_account'
  post 'teacher/save_settings' => 'teacher_account#save_settings'
  
  # teacher/classrooms app routes
  get 'classrooms_summary' => 'teacher_account#classrooms_summary'

  # teacher/classroom app routes
  get 'teacher/classroom' => 'teacher_account#classroom'
  get 'teacher/classroom_tags' => 'teacher_account#classroom_tags'
  get 'teacher/classroom_activities_and_performances' => 'teacher_account#classroom_activities_and_performances'
  post 'teacher/save_student_performances' => 'teacher_account#save_student_performances'
  get 'teacher/student_performance' => 'teacher_account#student_performance'
  post 'teacher/save_verify' => 'teacher_account#save_verify'
  post 'teacher/save_activities_sort_order' => 'teacher_account#save_activities_sort_order'
  get 'teacher/export_data' => 'teacher_account#export_data'
  post 'teacher/save_reflection' => 'teacher_account#save_reflection'

  # teacher/activities app routes
  get 'teacher/activities_tags' => 'teacher_account#activities_tags'
  get 'teacher/teacher_activities_and_classroom_assignment' => 'teacher_account#teacher_activities_and_classroom_assignment'
  get 'teacher/teacher_activities_options' => 'teacher_account#teacher_activities_options'
  post 'teacher/save_teacher_activity_assignment_and_options' => 'teacher_account#save_teacher_activity_assignment_and_options'
  get 'teacher/teacher_activities_and_tags' => 'teacher_account#teacher_activities_and_tags'
  post 'teacher/save_new_activity' => 'teacher_account#save_new_activity'
  get 'teacher/activity' => 'teacher_account#activity'
  post 'teacher/update_activity/:id' => 'teacher_account#update_activity'
  get 'teacher/classroom_assignments' => 'teacher_account#classroom_assignments'
  post 'teacher/assign_activities' => 'teacher_account#assign_activities'
  get 'teacher/student_performance_count' => 'teacher_account#student_performance_count'
  post 'teacher/delete_activity' => 'teacher_account#delete_activity'
  post 'teacher/save_activity_assignments' => 'teacher_account#save_activity_assignments'

  # teacher/students app routes
  get 'teacher/students' => 'teacher_account#students'
  get 'teacher/student' => 'teacher_account#student'
  get 'teacher/student_activities_and_performances' => 'teacher_account#student_activities_and_performances'
  get 'teacher/student_activity' => 'teacher_account#student_activity'
  get 'teacher/activity_and_performances' => 'teacher_account#activity_and_performances'
  get 'teacher/classroom_student_user' => 'teacher_account#classroom_student_user'
  post 'teacher/classroom_remove_student' => 'teacher_account#classroom_remove_student'

  # student routes
  get 'student_home' => 'student_account#index'
  get 'current_student_user' => 'student_account#current_student_user'

  # student/classrooms app routes
  get 'student/classrooms_summary' => 'student_account#classrooms_summary'
  get 'student/search_classroom_code' => 'student_account#search_classroom_code'
  get 'student/classroom_tags' => 'student_account#classroom_tags'
  post 'student/join_classroom' => 'student_account#join_classroom'

  # student/classroom app routes
  get 'student/classroom' => 'student_account#classroom'
  get 'student/classroom_activities_and_performances' => 'student_account#classroom_activities_and_performances'
  get 'student/activity' => 'student_account#activity'
  post 'student/save_student_performance' => 'student_account#save_student_performance'
  get 'student/activity_and_performances' => 'student_account#activity_and_performances'
  post 'student/save_new_activity_goal' => 'student_account#save_new_activity_goal'

  # student/settings routes
  post 'student/save_settings' => 'student_account#save_settings'

  # admin routes
  get 'admin' => 'admin#home'
  get 'admin/logged_in' => 'admin#logged_in'
  post 'admin/google_login_post' => 'admin#google_login_post'
  post 'admin/search_users' => 'admin#search_users'
  get 'admin/sign_out' => 'admin#sign_out'
  post 'admin/become_user' => 'admin#become_user'
  get 'admin/summary_metrics' => 'admin#summary_metrics'
  get 'admin/user_metrics' => 'admin#user_metrics'

  root to: "public_pages#home"
  # root to: "public_pages#index"

  resources :sessions, only: [:create, :destroy]
  resources :classroom
  resources :activities
  resources :student_performances
  resources :activity_tags
  resources :teacher_users
  resources :student_users
  resources :student_performance_verifications


end
