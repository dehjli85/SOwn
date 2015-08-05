Rails.application.routes.draw do

  resources :student_performance_verifications

  get 'student_account/home'

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

  
  post 'login_post' => 'public_pages#login_post'
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  # teacher routes
  get 'teacher_home' => 'teacher_account#index'
  get 'current_teacher_user' => 'teacher_account#current_teacher_user'

  # teacher/classrooms app routes
  get 'classrooms_summary' => 'teacher_account#classrooms_summary'
  post 'teacher/save_new_classroom' => 'teacher_account#save_new_classroom'

  # teacher/classroom app routes
  get 'teacher/classroom' => 'teacher_account#classroom'
  get 'teacher/classroom_tags' => 'teacher_account#classroom_tags'
  get 'teacher/classroom_activities_and_performances' => 'teacher_account#classroom_activities_and_performances'
  post 'teacher/save_student_performances' => 'teacher_account#save_student_performances'

  # teacher/activities app routes
  get 'teacher/teacher_activities_and_classroom_assignment' => 'teacher_account#teacher_activities_and_classroom_assignment'
  get 'teacher/teacher_activities_verifications' => 'teacher_account#teacher_activities_verifications'
  post 'teacher/save_teacher_activity_assignment_and_verifications' => 'teacher_account#save_teacher_activity_assignment_and_verifications'
  get 'teacher/teacher_activities_and_tags' => 'teacher_account#teacher_activities_and_tags'
  post 'teacher/save_new_activity' => 'teacher_account#save_new_activity'
  get 'teacher/activity' => 'teacher_account#activity'
  post 'teacher/update_activity/:id' => 'teacher_account#update_activity'
  get 'teacher/classroom_assignments' => 'teacher_account#classroom_assignments'
  post 'teacher/assign_activities' => 'teacher_account#assign_activities'

  # student routes
  get 'student_home' => 'student_account#index'
  get 'current_student_user' => 'student_account#current_student_user'

  # student/classrooms app routes
  get 'student/classrooms_summary' => 'student_account#classrooms_summary'

  # student/classroom app routes
  get 'student/classroom' => 'student_account#classroom'
  get 'student/classroom_activities_and_performances' => 'student_account#classroom_activities_and_performances'
  get 'student/activity' => 'student_account#activity'
  post 'student/save_student_performance' => 'student_account#save_student_performance'


  #old routes
  get 'student_home_old' => 'student_account#home'
  post 'student/joinClassroomConfirm' => 'student_account#join_classroom_confirm'
  post 'student/joinClassroomConfirmPost' => 'student_account#join_classroom_confirm_post'
  get 'student/viewClassroom' => 'student_account#view_classroom'  


  get 'teacher_home_old' => 'teacher_account#home'

  get 'student_performance/verify' => 'student_performances#verify'
  post 'student_performance/verify_post' => 'student_performances#verify_post'

  root to: "public_pages#home"

  resources :sessions, only: [:create, :destroy]
  resources :classroom
  resources :activities
  resources :student_performances
  resources :activity_tags
  resources :teacher_users
  resources :student_users

end
