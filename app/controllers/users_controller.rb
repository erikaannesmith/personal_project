class UsersController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save!
      session[:user_id] = @user.id
      if @user.designer?
        redirect_to designer_dashboard_path(@user)
        flash[:success] = "Successfully created account as a designer"
      elsif @user.producer?
        redirect_to producer_dashboard_path(@user)
        flash[:success] = "Successfully created account as a producer"
      end        
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if current_designer?
      redirect_to designer_dashboard_path(@user)
    elsif current_producer?
      redirect_to producer_dashboard_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :role, :name, :phone_number, :address, :city, :state, :postal_code)
  end

end