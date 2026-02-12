class SchedulesController < ApplicationController
  before_action :authenticate_user!

  def index
    @schedules = current_user.schedules.includes(:schedule_template, :comment_type)
  end

  def new
    @schedule = current_user.schedules.new
  end

  def create
    @schedule = current_user.schedules.new(schedule_params)

    if @schedule.save
      redirect_to schedules_path, notice: "予定を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end
end

private

def schedule_params
  params.require(:schedule).permit(
    :schedule_template_id,
    :comment_type_id,
    :scheduled_at,
    :notification_before_minutes,
    :status
  )
end