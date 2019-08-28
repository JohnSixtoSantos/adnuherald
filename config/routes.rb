Rails.application.routes.draw do
	root to: 'page#front_page'

  	get "dashboard", to: 'dashboard#dashboard'
	get "browse", to: "data#browse"
	get "view_data/:coll_id", to: "data#view_data"
	get "collections", to: "data#collections"
	get "upload_data", to: "data#upload_data"
	post "upload_data", to: "data#process_upload"
	get "topic", to: "topic#select_collection"
	post "topic", to: "topic#run_lda"
	get "geo", to: "geo#select_data"
	post "geo", to: "geo#display_set"
	get "sentiment", to: "sentiment#select_collection"
	post "sentiment", to: "sentiment#show_training_page"
	post "train_sentiment", to: "sentiment#train_model"
	post "sentiment/upload", to: "sentiment#process_upload"
	get "edit_data/:id", to: "data#edit_data"
	post "edit_data/:id", to: "data#update_data"
	get "delete_data/:id", to: "data#delete_data"
	get "summary", to: "summary#select_collection"
	post "summary", to: "summary#run_summarization"
	get "centrality", to: "centrality#select_collection"
	post "centrality", to: "centrality#calculate_centrality"

	get "topic/analyses/:cid", to: "topic#view_result_sets"
	get "topic/analyses/results/:cid", to: "topic#view_results"

	get "summary/analyses/:cid", to: "summary#view_result_sets"
	get "summary/analyses/results/:cid", to: "summary#view_results"

	get "sentiment/analyses/:cid", to: "sentiment#view_result_sets"
	get "sentiment/analyses/results/:cid", to: "sentiment#view_results"

	get "centrality/analyses/:cid", to: "centrality#view_result_sets"
	get "centrality/analyses/results/:cid", to: "centrality#view_results"

	get "login", to: "users#login"
	post "login", to: "users#login"
	get "logout", to: "user#logout"

	get "new_job", to: "data#new_job"
	get "stop_job", to: "data#stop_job"
	post "new_job", to: "data#create_job"

	get "/:p", to: "page#front_page"

	get "/export/:id", to: "data#export"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
