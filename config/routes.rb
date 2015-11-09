Rails.application.routes.draw do
  resources :tags do 
    collection do 
      get 'check'
    end
  end
end
