Rails.application.routes.draw do

  resources :documents, except: [:index, :show]

  post "/documents/process-upload/:client", to: "documents#process_upload"
  get "/documents/upload/:client", to: "documents#upload"
  get "/documents/:client", to: "documents#index"
  get "/documents/:client/:id", to: "documents#show"

  get "/api/documents/:client", to: "documents#api_get_documents"

end
