class CreateUsers < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'uuid-ossp'
    create_table :users, id: :uuid do |t|
      t.string :name, presence: true
      t.string :display_name
      t.string :email, presence: true
      t.boolean :terms_accepted, presence: true, default: false
      t.string :role, presence: true
      t.datetime :blocked_at, presence: false
      t.datetime :deleted_at, presence: false
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :name, unique: true
  end

  def down
    drop_table :users
  end
end
