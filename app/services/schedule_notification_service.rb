class ScheduleNotificationService
  def self.run
    now = Time.current
    line_service = LineMessagingService.new

    Schedule
      .pending
      .where(notified_at: nil)
      .where(scheduled_at: now..(now + 1.hour))
      .find_each do |schedule|

        notify_time = schedule.scheduled_at - schedule.notification_before_minutes.minutes
        next unless notify_time <= now

        begin
          line_service.send_schedule_notification(schedule)
          
          schedule.update!(notified_at: now)
          
          puts "通知送信完了(ID:#{schedule.id})"
        rescue => e
          Rails.logger.error "LINE送信失敗 (ID: #{schedule.id}): #{e.message}"
        end
      end
  end
end

