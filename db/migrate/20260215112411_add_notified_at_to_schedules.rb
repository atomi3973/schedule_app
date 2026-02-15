class AddNotifiedAtToSchedules < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :notified_at, :datetime
  end
end
