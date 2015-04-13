Rails.application.routes.draw do

  root 'dashboard#index'

  # Dashboard routes
  get 'dashboard/index', to: 'dashboard#index'
  get 'dashboard/admin', to: 'dashboard#admin'

  # Users routes
  get 'users/new_student'
  get 'users/new_advisor'
  post 'users/create_student', to: 'users#create_student'
  post 'users/create_advisor', to: 'users#create_advisor'
  get 'users/login', to: 'users#login'
  post 'users/verify_login', to: 'users#verify_login'
  get 'users/logout', to: 'users#logout'
  post 'users/edit', to: 'users#edit'

  # Clubs routes
  get 'clubs/index'
  get 'clubs/hub/:id', to: 'clubs#hub'
  get 'clubs/new'
  get 'clubs/manage', to: 'clubs#manage'
  post 'clubs/edit', to: 'clubs#edit'
  post 'clubs/create', to: 'clubs#create'
  post 'clubs/hub/:id/addcomment', to: 'clubs#addcomment'
  post 'clubs/hub/:id/add_students', to: 'clubs#add_students'
  post 'clubs/hub/:id/add_advisors', to: 'clubs#add_advisors'
  post 'clubs/hub/:id/drop_students', to: 'clubs#drop_students'
  post 'clubs/hub/:id/drop_advisors', to: 'clubs#drop_advisors'

  # Events routes
  get 'events/index'
  post 'events/edit', to: 'events#edit'
  get 'events/manage'
  get 'events/:id/new', to: 'events#new'
  get 'events/hub/:id', to: 'events#hub'
  get 'events/:id/manage', to: 'events#manage'
  post 'events/:id/create', to: 'events#create'
  post 'events/hub/:id/addcomment', to: 'events#addcomment'
  get 'events/:id/rsvp', to:'events#rsvp'
  get 'events/:id/leave', to:'events#leave'


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
end
