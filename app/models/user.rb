class User < ApplicationRecord
  ROLES = %w[admin therapist client].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { admin: 'admin', therapist: 'therapist', client: 'client' }, _suffix: true
  attribute :role, :string, default: 'client'

  ROLES.each do |name|
    define_method "#{name}?" do
      role == name
    end
  end
end
