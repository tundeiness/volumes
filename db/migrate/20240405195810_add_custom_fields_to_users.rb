class AddCustomFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :contact_number, :string
    add_column :users, :address, :string
    add_column :users, :username, :string
    add_column :users, :gender, :string
  end
end
