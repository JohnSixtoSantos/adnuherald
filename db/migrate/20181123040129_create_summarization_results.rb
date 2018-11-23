class CreateSummarizationResults < ActiveRecord::Migration[5.1]
  def change
    create_table :summarization_results do |t|
      t.string :root_word
      t.float :b_value
      t.string :summary

      t.timestamps
    end
  end
end
