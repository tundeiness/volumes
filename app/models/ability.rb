class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.therapist?
      can :manage, Appointment, therapist_id: user.id
      can :read, Client
    elsif user.client?
      # can :create, Appointment
      # can :read, Appointment, client_id: user.id
    end
    can :manage, User, id: user.id if user.admin?
  end
end