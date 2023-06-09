class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :avatar, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable,
         :validatable, :omniauthable, omniauth_providers: [:github]

  has_many :lots, dependent: :destroy
  has_many :bids, dependent: :destroy

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    user ||= User.create(
      name: user_name(data),
      surname: user_surname(data),
      email: data['email'],
      password: Devise.friendly_token[0, 20]
    )
    user
  end

  def self.user_name(data)
    data['name'].split.first
  end

  def self.user_surname(data)
    data['name'].split[1..].join
  end

  enum role: { user: 0, admin: 1 }
  after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :user
  end
end
