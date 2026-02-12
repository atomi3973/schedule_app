class ChangeStatusToIntegerInSchedules < ActiveRecord::Migration[7.2]
  def up
    # string カラムを削除
    remove_column :schedules, :status

    # integer カラムを追加（デフォルト 0 = pending）
    add_column :schedules, :status, :integer, null: false, default: 0
  end

  def down
    remove_column :schedules, :status
    add_column :schedules, :status, :string, null: false, default: "pending"
  end
end