class UsersController < ApplicationController
  
  def index
    @groups = Group.all
    @user = current_user
  end
  
  def show
    @user = current_user
  end

  def new
    @group = Group.new
  end

  def edit
    @user = user_params.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to root_path, notice: 'Category created successfully.'
    else
      render :new
    end
  end

  private

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to root_path, notice: 'Category destroyed successfully.'
  end
   
  def group_params
    params.require(:group).permit(:name, :icon)
  end

  def user_params
    params.require(:current_user).permit(:name, :email, :password, :password_confirmation, :icon)
  end
end
