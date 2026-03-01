class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule, only: %i[edit update destroy]

  def index
    @schedules = current_user.schedules.includes(:schedule_template, :comment_type).order(scheduled_at: :asc)

    if params[:title].present?
      @schedules = @schedules.joins(:schedule_template).where("schedule_templates.title LIKE ?", "%#{params[:title]}%")
    end

    if params[:start_date].present? && params[:end_date].present?
      @schedules = @schedules.where("DATE(scheduled_at) BETWEEN ? AND ?", params[:start_date], params[:end_date])
    elsif params[:start_date].present?
      @schedules = @schedules.where("DATE(scheduled_at) >= ?", params[:start_date])
    elsif params[:end_date].present?
      @schedules = @schedules.where("DATE(scheduled_at) <= ?", params[:end_date])
    end

    if params[:status] == "completed"
      @schedules = @schedules.where(status: 1)
    elsif params[:status] == "pending"
      @schedules = @schedules.where(status: 0)
    end
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
    @schedule.assign_attributes(schedule_params)

    if @schedule.status_changed? && @schedule.pending?
      @schedule.back_to_pending
    end

    respond_to do |format|
      if @schedule.save
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
