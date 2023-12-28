class PaymentsController < ApplicationController
  before_action :set_user
  before_action :set_group
  before_action :set_payment, only: %i[show edit update destroy]

  def index
    @payments = @group.payments.all
    @show_second_navbar = true
  end

  def show
    # @payment is already set through the before_action
  end

  def new
    @payment = Payment.new
    @show_second_navbar = true
  end

  def create
    @payment = @group.payments.new(payment_params)
    if @payment.save
      redirect_to user_group_path(@user, @group), notice: 'Payment was successfully created.'
    else
      render :new
    end
  end

  def edit
    # @payment is already set through the before_action
  end

  def update
    if @payment.update(payment_params)
      redirect_to users_path, notice: 'Payment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @payment.destroy
    redirect_to users_path, notice: 'Payment deleted.'
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_payment
    @payment = @group.payments.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def payment_params
    params.require(:payment).permit(:name, :amount)
  end
end
