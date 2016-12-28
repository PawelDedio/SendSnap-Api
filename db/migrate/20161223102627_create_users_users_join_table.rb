class CreateUsersUsersJoinTable < ActiveRecord::Migration[5.0]
  def up
    create_table :users_users, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :friend_id, null: false
      t.timestamps
    end

    add_index :users_users, :user_id
    add_index :users_users, :friend_id
  end

  def down
    drop_table :users_users
  end
end
