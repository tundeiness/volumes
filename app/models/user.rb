class User < ApplicationRecord
  ROLES = %w[admin therapist client].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def client?
    role == 'client'
  end

  validates :username, presence: true, uniqueness: true, if: :client?
  validates :email, presence: true, uniqueness: true

  enum role: { admin: 'admin', therapist: 'therapist', client: 'client' }, _suffix: true
  # enum role: [ :admin, :therapist, :client ], validate: true
  attribute :role, :string, default: 'client'

  ROLES.each do |name|
    define_method "#{name}?" do
      role == name
    end
  end
end
