require 'net/http'
require 'uri'
require 'json'

class AiCommentService
  def self.generate(schedule)
    api_key = ENV['GEMINI_API_KEY']
    
   
    uri = URI.parse("https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=#{api_key}")
    
    prompt = "あなたは親切なリマインドアシスタントです。予定「#{schedule.schedule_template.title}」に合わせて、ユーザーを励ます15文字以内の短い一言を作成してください。"

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
        # 404が出た場合、このログに詳細が出ます
        Rails.logger.error "Gemini最終エラー: #{response.body}"
        "リマインドです！頑張りましょう✨"
      end
    rescue => e
      "応援しています！"
    end
  end
end