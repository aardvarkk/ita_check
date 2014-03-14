class AddQueryIdToQueryResult < ActiveRecord::Migration
  def change
    add_column :query_results, :query_id, :integer, null: false, default: 1
  end
end
