class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :origins
      t.string :destinations
      t.string :origin_dates
      t.string :destination_dates

      t.timestamps
    end
  end
end
