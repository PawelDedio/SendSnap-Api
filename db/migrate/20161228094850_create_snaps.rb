class CreateSnaps < ActiveRecord::Migration[5.0]
  def up
    create_table :snaps, id: :uuid do |t|
      t.references :user, type: :uuid, index: true, null: false
      t.string :snap_file, null: false
      t.string :snap_type, null: false
      t.integer :duration, null: false
      t.timestamps
    end
  end

  def down
    drop_table :snaps
  end
end
