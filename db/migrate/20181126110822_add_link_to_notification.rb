class AddLinkToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :link, :string
  end
end
