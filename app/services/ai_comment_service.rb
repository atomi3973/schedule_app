class AiCommentService
  def self.generate(schedule)
    client = Gemini.new(
      credentials: {
        api_key: ENV['GEMINI_API_KEY']
      },
      options: { 
        model: 'gemini-1.5-flash', 
        version: 'v1beta' 
      }
    )
    
    prompt = <<~PROMPT
      あなたは親切なリマインドアシスタントです。
      以下の予定に合わせて、ユーザーが前向きになれるような短い一言メッセージを1つ作成してください。
      
      予定: #{schedule.schedule_template.title}
      タイプ: #{schedule.comment_type.name}
      
      条件：
      - 60文字以内。
      - 絵文字を1つか2つ含める。
      - 予定の内容に寄り添った励ましにする。
    PROMPT

    begin
      result = client.generate_content({
        contents: [{ role: 'user', parts: [{ text: prompt }] }]
      })
      
      if result && result["candidates"]
        result.dig("candidates", 0, "content", "parts", 0, "text")
      else
        "今日も一日応援しています！"
      end
    rescue => e
      Rails.logger.error "Gemini生成失敗: #{e.message}"
      "リマインドです。頑張りましょう！"
    end
  end
end