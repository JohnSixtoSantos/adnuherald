class FixWordAttributes < ActiveRecord::Migration[5.1]
  def change
  end

  def self.up
    rename_column :words, :word, :text
  end
end
