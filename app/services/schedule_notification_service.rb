class ScheduleNotificationService
  def self.run
    now = Time.current
    line_service = LineMessagingService.new # インスタンス化は一度でOK

    Schedule
      .pending
      .includes(:user, :schedule_template)
      .where(scheduled_at: (now - 1.day)..now)
      .find_each do |schedule|

        notify_time = schedule.scheduled_at - schedule.notification_before_minutes.minutes
        next unless notify_time <= now

        begin
          # 定義されている正しいメソッドを呼び出す
          # 引数には schedule オブジェクトをそのまま渡します
          line_service.send_schedule_notification(schedule)
          
          puts "通知送信完了(ID:#{schedule.id})"
        rescue => e
          Rails.logger.error "LINE送信失敗 (ID: #{schedule.id}): #{e.message}"
        end
      end
  end
end

