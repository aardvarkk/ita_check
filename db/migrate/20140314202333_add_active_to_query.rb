class AddActiveToQuery < ActiveRecord::Migration
  def change
    add_column :queries, :active, :boolean, null: false, default: true
  end
end
