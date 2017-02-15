class CreateUserChatSubscriptions < ActiveRecord::Migration[5.0]
  def up
    create_table :user_chat_subscriptions, id: :uuid do |t|
      t.references :user, type: :uuid, index: true
      t.uuid :participant_id, index: true
      t.timestamps
    end
  end

  def down
    drop_table :user_chat_subscriptions
  end
end
