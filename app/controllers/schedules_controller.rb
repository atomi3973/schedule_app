class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule, only: %i[edit update destroy]

  def index
    @schedules = current_user.schedules.includes(:schedule_template, :comment_type)
  end

  def new
    @schedule = current_user.schedules.new
  end

  def create
    @schedule = current_user.schedules.new(schedule_params)

    respond_to do |format|
      if @schedule.save
        format.turbo_stream { render "create" }
        format.html { redirect_to schedules_path, notice: "予定を登録しました" }
      else
        format.turbo_stream { render "form_errors" }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.turbo_stream { render "update" }
        format.html { redirect_to schedules_path, notice: "予定を更新しました" }
      else
        format.turbo_stream { render "form_errors" }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @schedule.destroy

    respond_to do |format|
      format.turbo_stream { render "destroy" }
      format.html { redirect_to schedules_path, notice: "予定を削除しました" }
    end
  end

  private

  def set_schedule
    @schedule = current_user.schedules.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(
      :schedule_template_id, :comment_type_id, :scheduled_at, :notification_before_minutes, :status
    )
  end
end
