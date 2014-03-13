class CreateQueryResults < ActiveRecord::Migration
  def change
    create_table :query_results do |t|
      t.string :itinerary
      t.decimal :price

      t.timestamps
    end
  end
end
