require 'line-bot-api'

class LineMessagingService
  def initialize
    @client = Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV['LINE_MESSAGING_CHANNEL_TOKEN']
    )
  end

  # 予定通知
  def send_schedule_notification(schedule, ai_message = nil)
    return if schedule.user.uid.blank?

    text = <<~TEXT
      ⏰ 予定の時間です

      📌 内容：
      #{schedule.schedule_template.title}

      #{ai_message if ai_message.present?}

      ✅ 完了にする場合は
      「完了 #{schedule.id}」
      と返信してください
    TEXT
    # ↑この TEXT が抜けていたか、インデント（空白）に全角スペースなどが混ざっていた可能性があります

    message = Line::Bot::V2::MessagingApi::TextMessage.new(text: text)

    request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
      to: schedule.user.uid,
      messages: [message]
    )

    @client.push_message(push_message_request: request)
  end
end