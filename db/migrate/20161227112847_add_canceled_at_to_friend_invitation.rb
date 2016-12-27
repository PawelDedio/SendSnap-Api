class AddCanceledAtToFriendInvitation < ActiveRecord::Migration[5.0]
  def up
    add_column :friend_invitations, :canceled_at, :datetime, null: true
  end

  def down
    remove_column :friend_invitations,:canceled_at
  end
end
