class AddCollectionIdToSummarizationResult < ActiveRecord::Migration[5.1]
  def change
    add_column :summarization_results, :collection_id, :integer
  end
end
