class AddLastReplayAtForUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :last_replay_at, :datetime, null: true
  end

  def down
    remove_column :users, :last_replay_at
  end
end
