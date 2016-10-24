class UsersController < Clearance::UsersController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    working_params = user_params_revised
    working_params.delete(:password)

    if current_user.update(working_params)
      if params[:user][:remove_avatar] == 1
        current_user.remove_avatar!
        current_user.save
      end
      redirect_to current_user
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    sign_out
    @user.destroy
    redirect_to root_path
  end


  private

  def user_from_params
    name = user_params.delete(:name)
    email = user_params.delete(:email)
    password = user_params.delete(:password)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.name = name
      user.email = email
      user.password = password
    end
  end

  def user_params_revised
    params.require(:user).permit(:name, :email, :password, :avatar)
  end
end
