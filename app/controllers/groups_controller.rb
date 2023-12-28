class GroupsController < ApplicationController
  before_action :set_group, only: %i[update destroy]
  before_action :set_user, only: %i[create show edit update destroy]

  def index
    @user = current_user
    @groups = Group.where(user: @user)
    @show_second_navbar = true
  end

  def show
    @group = Group.find(params[:id])
    @recent_payments = @group.recent_payments
    @total_amount = @group.total_amount
    @show_second_navbar = true
  end

  def new
    @user = current_user
    @group = Group.new
    @show_second_navbar = true
  end

  def create
    @show_second_navbar = true
    @group = Group.new(group_params)
    @group.user = current_user.name
    if @group.save
      redirect_to users_path, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
    @show_second_navbar = true
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to users_path, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to users_path, notice: 'Group was successfully destroyed.'
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def group_params
    params.require(:group).permit(:name, :icon, :payments_id)
  end
end
