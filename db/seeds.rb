# db/seeds.rb

# Schedule Templates共通
["病院", "勉強", "友達", "ご飯"].each do |title|
  ScheduleTemplate.find_or_create_by!(title: title)
end

# CommentType
CommentType.find_or_create_by!(name: "ポジティブ") do |ct|
  ct.description = "ポジティブに通知する"
end

CommentType.find_or_create_by!(name: "罪悪感") do |ct|
  ct.description = "罪悪感がある通知"
end

CommentType.find_or_create_by!(name: "後悔") do |ct|
  ct.description = "後悔を漂わせる通知"
end

CommentType.find_or_create_by!(name: "応援") do |ct|
  ct.description = "応援する通知"
end

