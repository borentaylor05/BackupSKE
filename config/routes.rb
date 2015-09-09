Rails.application.routes.draw do

  resources :documents, except: [:index, :show]

  post "/documents/process-upload/:token", to: "documents#process_upload"
  get "/documents/upload/:token", to: "documents#upload"
  get "/documents/:token", to: "documents#index"
  get "/documents/:token/:id", to: "documents#show"

  get "/api/documents/:token", to: "documents#api_get_documents"

end
