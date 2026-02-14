require 'line-bot-api'

class LineBotController < ApplicationController
  protect_from_forgery except: :callback

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    parser = Line::Bot::V2::WebhookParser.new(
      channel_secret: ENV['LINE_MESSAGING_CHANNEL_SECRET']
    )

    events = parser.parse(body: body, signature: signature)

    client = Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV['LINE_MESSAGING_CHANNEL_TOKEN']
    )

    events.each do |event|
      next unless event.is_a?(Line::Bot::V2::Webhook::MessageEvent)
      next unless event.message.is_a?(Line::Bot::V2::Webhook::TextMessageContent)

      reply_text = handle_text(event)

      message = Line::Bot::V2::MessagingApi::TextMessage.new(text: reply_text)

      reply_request = Line::Bot::V2::MessagingApi::ReplyMessageRequest.new(
        reply_token: event.reply_token,
        messages: [message]
      )

      client.reply_message(reply_message_request: reply_request)
    end

    render plain: "OK"
  rescue Line::Bot::V2::WebhookParser::InvalidSignatureError
    render plain: "Bad Request", status: :bad_request
  end

  private

  def handle_text(event)
    text = event.message.text.strip
    user = User.find_by(uid: event.source.user_id)

    return "❌ ユーザーが登録されていません" unless user

    # ===== 完了コマンド（スペース不要対応） =====
    if text.match?(/\A完了\s*\d+\z/)
      schedule_id = text.gsub(/\D/, "").to_i
      schedule = user.schedules.find_by(id: schedule_id)

      return "❌ その予定は見つかりません" unless schedule

      schedule.update!(status: "done")
      return "✅「#{schedule.schedule_template.title}」を完了にしました！"
    end

    # ===== ヘルプ =====
    <<~TEXT
      使い方：
      ・完了15
      ・完了 15

      ※ 数字は予定IDです
    TEXT
  end
end
