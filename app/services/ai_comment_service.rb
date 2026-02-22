class AiCommentService
  def self.generate(schedule)
    client = Gemini.new(
      credentials: {
        api_key: ENV['GEMINI_API_KEY']
      },
      options: { model: 'gemini-1.5-flash', server_sent_events: true }
    )
    
    prompt = <<~PROMPT
      あなたは親切なリマインドアシスタントです。
      以下の予定に合わせて、ユーザーが前向きになれるような短い一言メッセージを1つ作成してください。
      
      予定: #{schedule.schedule_template.title}
      タイプ: #{schedule.comment_type.name}
      
      条件：
      - 60文字以内。
      - 絵文字を1つか2つ含める。
      - 「頑張ってください」だけでなく、予定に寄り添った内容にする。
    PROMPT

    begin
      result = client.generate_content({
        contents: [{ role: 'user', parts: [{ text: prompt }] }]
      })
      
      result.dig("candidates", 0, "content", "parts", 0, "text") || "今日も素敵な一日を！"
    rescue => e
      Rails.logger.error "Gemini生成失敗: #{e.message}"
      "リマインドです！頑張りましょう！" # 失敗時のバックアップ
    end
  end
end