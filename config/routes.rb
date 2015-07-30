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

  get 'teacher_home' => 'teacher_account#index'
  get 'current_teacher_user' => 'teacher_account#current_teacher_user'
  get 'classrooms_summary' => 'teacher_account#classrooms_summary'
  get 'teacher/classroom' => 'teacher_account#classroom'
  get 'teacher/classroom_tags' => 'teacher_account#classroom_tags'
  get 'teacher/classroom_activities_and_performances' => 'teacher_account#classroom_activities_and_performances'
  get 'teacher/teacher_activities_and_classroom_assignment' => 'teacher_account#teacher_activities_and_classroom_assignment'
  get 'teacher/teacher_activities_verifications' => 'teacher_account#teacher_activities_verifications'
  post 'teacher/save_teacher_activity_assignment_and_verifications' => 'teacher_account#save_teacher_activity_assignment_and_verifications'
  get 'teacher/teacher_activities_and_tags' => 'teacher_account#teacher_activities_and_tags'
  get 'teacher_home_old' => 'teacher_account#home'

  get 'student_home' => 'student_account#home'
  post 'student/joinClassroomConfirm' => 'student_account#join_classroom_confirm'
  post 'student/joinClassroomConfirmPost' => 'student_account#join_classroom_confirm_post'
  get 'student/viewClassroom' => 'student_account#view_classroom'  

  get 'activities/assign/:id' => 'activities#assign'
  post '/assign_activities' => 'classroom_activity_pairing#assign'

  get 'student_performance/edit_all' => 'student_performances#edit_all'
  post 'student_performance/save_all' => 'student_performances#save_all'
  get 'student_performance/verify' => 'student_performances#verify'
  post 'student_performance/verify_post' => 'student_performances#verify_post'

  get 'classroom/edit_activities' => 'classroom#edit_activities'
  post 'classroom/save_activities' => 'classroom#save_activities'
  get 'classroom/classroom_error' => 'classroom#classroom_error'

  root to: "public_pages#home"

  resources :sessions, only: [:create, :destroy]
  resources :classroom
  resources :activities
  resources :student_performances
  resources :activity_tags
  resources :teacher_users
  resources :student_users

end
