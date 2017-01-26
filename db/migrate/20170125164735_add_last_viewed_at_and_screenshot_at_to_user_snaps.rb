class AddLastViewedAtAndScreenshotAtToUserSnaps < ActiveRecord::Migration[5.0]
  def up
    add_column :user_snaps, :last_viewed_at, :datetime, null: true
    add_column :user_snaps, :screenshot_at, :datetime, null: true
  end

  def down
    remove_column :user_snaps, :last_viewed_at
    remove_column :user_snaps, :screenshot_at
  end
end
