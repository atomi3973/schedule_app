class ChangeUserIdNullOnScheduleTemplates < ActiveRecord::Migration[7.2]
  def change
    change_column_null :schedule_templates, :user_id, true
  end
end
