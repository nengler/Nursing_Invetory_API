Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      post "/create_user", to: "users#create"
      delete "/delete_user", to: "users#destroy"
      resources :categories
      resources :items
      resources :scanned_outs

      get "/user_is_authed", to: "auth#user_is_authed"

      #login
      post "/login", to: "auth#login"

      #home page
      get "/get_last_five", to: "scanned_ins#grab_last_5"
      get "/get_last_five_scanned_out", to: "scanned_outs#grab_last_5"
      get "/threshold_items", to: "items#items_below_threshold"
      
      #scan page
      post "/scan_in", to: "scanned_ins#process_scan_in"
      post "/scan_out", to: "scanned_outs#process_scan_out"
      post "/details", to: "items#show"

      #inventory
      delete "/delete_item", to: "items#destroy"
      patch "/update_item", to: "items#update"
      get "/get_all_items", to: "items#index"
      post "/search_field_item", to: "items#item_by_name"
      get "/report_page", to: "items#filter_items"
      delete "/delete_category", to: "categories#destroy"
      patch "/update_category", to: "categories#update"

      #trend report
      post "/scanned_out_by_category", to: "scanned_outs#items_by_category"
      
    end
  end
end
