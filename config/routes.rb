Rails.application.routes.draw do
  get 'page/index'
  root to: 'page#index'

	get "browse", to: "data#browse"
	get "view_data/:coll_id", to: "data#view_data"
	get "collections", to: "data#collections"
	get "upload_data", to: "data#upload_data"
	post "upload_data", to: "data#process_upload"
	get "topic", to: "topic#select_collection"
	post "topic", to: "topic#run_lda"
	get "geo", to: "geo#select_data"
	get "sentiment", to: "sentiment#select_collection"
	post "sentiment", to: "sentiment#show_training_page"
	post "train_sentiment", to: "sentiment#train_model"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
