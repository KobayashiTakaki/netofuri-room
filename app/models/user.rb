class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_one :joining, dependent: :destroy

  has_secure_password
  VALID_NAME_REGEX = /\A[\w\-_]+\z/
  validates :name,
    presence: { message: "アカウント名は必須です" },
    uniqueness: { message: "既に存在するアカウント名です" },
    length: { in: 1..30,
      message: "アカウント名は30文字以内でお願いします。"
    },
    format: { with: VALID_NAME_REGEX,
      message: "アカウント名は半角英数字、\"-\"(半角ハイフン)、\"_\"(半角アンダーバー)のみが使用できます。"
    }

  validates :display_name,
    length: { maximum: 30,
      message: "表示名は30文字以内でお願いします。"
    }

    def join(room)
      leave
      viewing = Viewing.where(room: room).active_at(Time.zone.now).first
      Joining.create!(user: self, viewing: viewing)
    end

    def leave
      joining.destroy! if joining
    end

end
