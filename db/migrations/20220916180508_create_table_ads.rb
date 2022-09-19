require 'sequel'

Sequel.migration do
  change do
    create_table(:ads) do
      primary_key :id
      column :user_id, Integer, null: false, index: true
      column :title, String, null: false
      column :description, 'text', null: false
      column :city, String, null: false
      column :lat, Float
      column :lon, Float
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
