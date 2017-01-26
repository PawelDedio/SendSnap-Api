class CreateChatMessages < ActiveRecord::Migration[5.0]
  def up
    create_table :chat_messages, id: :uuid do |t|
      t.uuid :author_id, null: false
      t.uuid :recipient_id, null: false
      t.text :message, null: false
      t.datetime :readed_at, null: true
      t.timestamps
    end

    add_index :chat_messages, [:author_id, :recipient_id]
  end

  def down
    drop_table :chat_messages
  end
end
