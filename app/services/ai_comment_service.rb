require 'net/http'
require 'uri'
require 'json'

class AiCommentService
  def self.generate(schedule)
    api_key = ENV['GEMINI_API_KEY']
    
   
    uri = URI.parse("https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=#{api_key}")
    
   
    prompt = <<~PROMPT
      あなたは親切なリマインドアシスタントです。
      予定「#{schedule.schedule_template.title}」に合わせて、ユーザーを励ます15文字以内の短い一言を作成してください。

      【重要ルール】
      - 挨拶、解説、提案、句読点の羅列は一切不要です。
      - 「はい、承知いたしました」や「いかがでしょうか」等の前置き・後書きも絶対に書かないでください。
      - 出力は「励ましの一言」そのもの1つだけにしてください。
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
      
        ai_response = result.dig("candidates", 0, "content", "parts", 0, "text").strip
        
        ai_response.split("\n").first
      else
        Rails.logger.error "Gemini API Error: #{response.body}"
        "リマインドです！頑張りましょう✨"
      end
    rescue => e
      Rails.logger.error "Gemini接続失敗: #{e.message}"
      "応援しています！"
    end
  end
end