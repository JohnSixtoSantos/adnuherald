class CreateTopicAnalysisResults < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_analysis_results do |t|
      t.string :description
      t.integer :collection_id

      t.timestamps
    end
  end
end
