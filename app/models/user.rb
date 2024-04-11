class User < ApplicationRecord
  ROLES = %w[admin therapist client].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  validates :username, presence: true, uniqueness: true
  # validates :username, presence: true
  validates :email, presence: true, uniqueness: true

  # validate :username_presence_for_client_role


  enum role: { admin: 'admin', therapist: 'therapist', client: 'client' }, _suffix: true
  # enum role: [ :admin, :therapist, :client ], validate: true
  attribute :role, :string, default: 'client'

  # after_initialize :set_default_role, if: :new_record?

  # def set_default_role
  #   self.role ||= :client
  # end

  ROLES.each do |name|
    define_method "#{name}?" do
      role == name
    end
  end

  # private

  # def client?
  #   role == 'client'
  # end

  # def username_presence_for_client_role
  #   if client? && username.blank?
  #     errors.add(:username, "can't be blank for client users")
  #   end
  # end
end
