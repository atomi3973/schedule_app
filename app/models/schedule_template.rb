class ScheduleTemplate < ApplicationRecord
  belongs_to :user, optional: true

  has_many :schedules, dependent: :nullify

  validates :title, presence: true
end
