class UsersController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    @user = User.includes(posts: :council).find(params[:id])
  end

  def edit
    if @tab.nil?
      if params[:tab].present?
        @tab = params[:tab]
      else
        @tab = :profile
      end
    end
  end

  def update
    @tab = :profile
    if current_user.update(user_params)
      flash[:notice] = alert_update(User)
      render :edit, status: 200
    else
      render :edit, status: 422
    end
  end

  def update_account
    @tab = :account
    if current_user.update_with_password(account_params)
      flash[:notice] = t('model.user.account_updated')
      render :edit, status: 200
    else
      flash[:alert] = t('model.user.password_required')
      render :edit, status: 422
    end
  end

  def update_password
    @tab = :password
    if current_user.update_with_password(password_params)
      flash[:notice] = t('model.user.password_updated')
      sign_in current_user, bypass: true
      render :edit, status: 200
    else
      flash[:alert] = t('model.user.password_required')
      render :edit, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :program, :start_year,
                                 :avatar, :student_id, :phone, :display_phone,
                                 :remove_avatar, :food_custom, food_preferences: [])
  end

  def account_params
    params.require(:user).permit(:email, :current_password)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
