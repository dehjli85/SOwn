Rails.application.routes.draw do

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

  get 'login' => 'public_pages#login'
  post 'login_post' => 'public_pages#login_post'
  get 'sign_up_teacher' => 'public_pages#sign_up_teacher'
  get 'sign_up_student' => 'public_pages#sign_up_student'
  get 'sign_up_error' => 'public_pages#sign_up_error'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  get 'teacher_home' => 'teacher_account#home'

  get 'student_home' => 'student_account#home'
  post 'student/joinClassroomConfirm' => 'student_account#join_classroom_confirm'
  post 'student/joinClassroomConfirmPost' => 'student_account#join_classroom_confirm_post'
  get 'student/viewClassroom' => 'student_account#view_classroom'  

  get 'activities/assign/:id' => 'activities#assign'
  post '/assign_activities' => 'classroom_activity_pairing#assign'

  get 'student_performance/edit_all' => 'student_performances#edit_all'
  post 'student_performance/save_all' => 'student_performances#save_all'

  root to: "public_pages#home"

  resources :sessions, only: [:create, :destroy]
  resources :classroom
  resources :activities
  resources :student_performances
  resources :activity_tags
  resources :teacher_users

end
