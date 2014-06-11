class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.text :description, null: false
      t.integer :members_id, allow_nil: true
      t.timestamps
    end
  end
end
