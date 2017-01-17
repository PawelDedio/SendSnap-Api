class CreateUserDevices < ActiveRecord::Migration[5.0]
  def up
    create_table :user_devices, id: :uuid do |t|
      t.references :user, type: :uuid, index: true, null: false
      t.string :registration_id, null: false
      t.string :device_type, null: false, index: true
      t.string :device_id, null: false
      t.timestamps
    end
  end

  def down
    drop_table :user_devices
  end
end
