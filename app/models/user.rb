class User < ApplicationRecord
  devise :database_authenticatable,
         :rememberable,
         :omniauthable,
         omniauth_providers: %i[line]

  def self.from_omniauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)

    user.name  = auth.info.name
    user.image = auth.info.image

    # LINEはメール取得が任意なので、なければダミーを入れる
    user.email ||= "#{auth.uid}-#{auth.provider}@example.com"

    user.save!
    user
  end
end