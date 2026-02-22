require 'net/http'
require 'uri'
require 'json'

class AiCommentService
  def self.generate(schedule)
    api_key = ENV['GEMINI_API_KEY']
    uri = URI.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=#{api_key}")
    
    prompt = <<~PROMPT
      あなたは親切なリマインドアシスタントです。
      以下の予定に合わせて、ユーザーが前向きになれるような短い一言メッセージを1つ作成してください。
      
      予定: #{schedule.schedule_template.title}
      内容: #{schedule.comment_type.name}
      
      条件：
      - 60文字以内。
      - 絵文字を1つか2つ含める。
      - 予定に寄り添った励ましにする。
    PROMPT

    header = { 'Content-Type': 'application/json' }
    body = {
      contents: [{
        parts: [{ text: prompt }]
      }]
    }

    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = body.to_json

      response = http.request(request)
      result = JSON.parse(response.body)

      if result["candidates"] && result.dig("candidates", 0, "content", "parts", 0, "text")
        result.dig("candidates", 0, "content", "parts", 0, "text").strip
      else
        Rails.logger.error "Gemini API Error Response: #{response.body}"
        "今日も一日応援しています！"
      end
    rescue => e
      Rails.logger.error "Gemini接続失敗: #{e.message}"
      "リマインドです！頑張りましょう✨"
    end
  end
end