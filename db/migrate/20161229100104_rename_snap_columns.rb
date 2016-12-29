class RenameSnapColumns < ActiveRecord::Migration[5.0]
  def up
    rename_column :snaps, :snap_file, :file
    rename_column :snaps, :snap_type, :file_type
  end

  def down
    rename_column :snaps, :file, :snap_file
    rename_column :snaps, :file_type, :snap_type
  end
end
