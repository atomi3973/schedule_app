require 'net/http'
require 'uri'
require 'json'

class AiCommentService
  def self.generate(schedule)
    api_key = ENV['GEMINI_API_KEY']
    
    uri = URI.parse("https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=#{api_key}")

    comment_type = schedule.comment_type || "応援"
    title = schedule.schedule_template.title

    prompt = <<~PROMPT
      あなたは親切なリマインドアシスタントです。
      予定「#{title}」の時間になったユーザーに対し、【#{comment_type}】という気分に寄り添った15文字以内の短い一言を作成してください。

      【気分ごとの演じ分けルール】
      - ポジティブ：最高の笑顔が見えるような、明るく前向きな応援。
      - 応援：背中をそっと押すような、心強い味方としての励まし。
      - 後悔：過去は気にせず、前を向けるような優しいフォロー。
      - 罪悪感：自分を責めないで、と包み込むような温かい言葉。

      【絶対守るべきルール】
      - 挨拶、解説、提案（「〜はいかがでしょうか」など）は一切書かない。
      - 返信は「励ましの一言」そのもの1つだけを出力する。
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
        # 最初の1行だけを取得し、余計な空白を削除
        result.dig("candidates", 0, "content", "parts", 0, "text").strip.split("\n").first
      else
        "#{title}の時間ですよ。応援しています！"
      end
    rescue => e
      Rails.logger.error "Gemini接続エラー: #{e.message}"
      "#{title}、頑張りましょう！"
    end
  end
end