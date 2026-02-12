class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :schedule_template
  belongs_to :comment_type

  validates :scheduled_at, presence: true
  validates :notification_before_minutes, presence: true
  validates :status, presence: true

  enum status: { pending: 0, done: 1 }
end
