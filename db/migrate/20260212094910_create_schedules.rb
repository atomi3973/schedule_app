class CreateSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :schedules do |t|
      t.references :user, null: false, foreign_key: true
      t.references :schedule_template, null: false, foreign_key: true
      t.references :comment_type, null: false, foreign_key: true
      t.datetime :scheduled_at, null: false
      t.integer :notification_before_minutes, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
