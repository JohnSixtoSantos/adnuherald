class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :password
      t.string :description
      t.string :photo
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :affiliation
      t.string :contact_number
      t.integer :account_type

      t.timestamps
    end
  end
end
