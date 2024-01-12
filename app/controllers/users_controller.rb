class UsersController < ApplicationController
  def index
    @groups = Group.all
    @user = current_user
    @show_first_navbar = true
    @total_credits = total_credits
  end

  def show
    @user = current_user
    @show_second_navbar = true
  end

  def new
    @group = Group.new
    @show_second_navbar = true
  end

  def edit
    @user = user_params.find(params[:id])
    @show_second_navbar = true
  end

  def create
    @show_second_navbar = true
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

def total_credits
  total_credits = 0

  Group.all.each do |group|
    total_credits += group.total_amount
  end

  total_credits
end
