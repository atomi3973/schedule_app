set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
#db作成後下記を設定
bundle exec rails db:migrate