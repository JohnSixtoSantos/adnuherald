class CreateTopicAnalysisResults < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_analysis_results do |t|
      t.integer :num_topics
      t.integer :num_words
      t.integer :collection_id
      t.string :description

      t.timestamps
    end
  end
end
