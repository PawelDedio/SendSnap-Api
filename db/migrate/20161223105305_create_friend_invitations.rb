class CreateFriendInvitations < ActiveRecord::Migration[5.0]
  def up
    create_table :friend_invitations, id: :uuid do |t|
      t.references :author, references: :users, index: true, null: false, type: :uuid
      t.references :recipient, references: :users, index: true, null: false, type: :uuid
      t.datetime :accepted_at, null: true
      t.datetime :rejected_at, null: true
      t.timestamps
    end
  end

  def down
    drop_table :friend_invitations
  end
end
