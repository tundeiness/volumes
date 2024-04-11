class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :authorize_admin!, only: %i[edit update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    Rails.logger.debug "Params received in create action: #{params.inspect}"

    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user != current_user && @user.update(user_params)
      flash[:notice] = 'User role updated successfully.'
      redirect_to users_path
    else
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to root_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'User was successfully destroyed.'
  end

  private

  def authorize_admin!
    if current_user.admin? && current_user == @user
      redirect_to root_path, alert: 'Admin cannot change their own role.'
    elsif current_user.admin?
      # Admins can only edit other users' roles
      nil
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :contact_number, :username, :address, :role, :gender, :email, :password, :password_confirmation)
  end

  # def user_params
  #   permitted_params = %i[first_name last_name contact_number address gender email password password_confirmation role]
  #   permitted_params << :username if params[:user]&.[](:role)&.to_s == 'client'
  #   params.require(:user).permit(permitted_params)
  # end
end
