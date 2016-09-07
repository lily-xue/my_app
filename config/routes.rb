Rails.application.routes.draw do
resources :applications,except: [:delete, :show]

    get '/login', to: 'sessions#new'           # 获取登录表路由
    post '/login', to: 'sessions#create'       # 登录路由
    delete '/logout', to: 'sessions#destroy'   # 登出路由
  root to: 'applications#index'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
