class CreateUserSnaps < ActiveRecord::Migration[5.0]
  def up
    create_table :user_snaps do |t|
      t.uuid :user_id, null: false
      t.uuid :snap_id, null: false
      t.integer :view_count, default: 0, null: false
      t.timestamps
    end

    add_index :user_snaps, [:user_id, :snap_id]
  end

  def down
    drop_table :user_snaps
  end
end
