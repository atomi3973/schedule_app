require 'google_generative_ai'

class AiCommentService
  def self.generate(schedule)
    client = GoogleGenerativeAI::Client.new(api_key: ENV['GEMINI_API_KEY'])
    
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

    begin
      response = client.generate_content(prompt, model: 'gemini-1.5-flash')
      
      if response.text.present?
        response.text.strip
      else
        "今日も一日応援しています！"
      end
    rescue => e
      Rails.logger.error "Gemini APIエラー: #{e.message}"
      "リマインドです！頑張りましょう✨"
    end
  end
end