class CreateFriendInvitations < ActiveRecord::Migration[5.0]
  def up
    create_table :friend_invitations, id: :uuid do |t|
      t.uuid :author_id, null: false
      t.uuid :recipient_id, null: false
      t.datetime :accepted_at, null: true
      t.datetime :rejected_at, null: true
      t.timestamps
    end

    add_index :friend_invitations, [:author_id, :recipient_id], unique: true
  end

  def down
    drop_table :friend_invitations
  end
end
