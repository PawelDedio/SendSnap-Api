class RenameReadedAtInChatMessages < ActiveRecord::Migration[5.0]
  def change
    rename_column :chat_messages, :readed_at, :read_at
  end
end
