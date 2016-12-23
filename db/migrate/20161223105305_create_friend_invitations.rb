class CreateFriendInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :friend_invitations do |t|

      t.timestamps
    end
  end
end
