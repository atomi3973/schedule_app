class SchedulerController < ApplicationController
  protect_from_forgery with: :null_session

  def execute
    if params[:auth_token].present? && params[:auth_token] == ENV['SCHEDULER_AUTH_TOKEN']
      ScheduleNotificationService.run
      render json: { status: 'success' }, status: :ok
    else
      render json: { status: 'unauthorized' }, status: :unauthorized
    end
  end
end