class UsersController < Clearance::UsersController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    byebug
    if current_user.update(user_params)
      redirect_to current_user
    else
      render :edit
    end
  end

  def destroy
    current_user.destroy
    redirect_to sign_out_path
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

  def user_params
    params[Clearance.configuration.user_parameter] || Hash.new
  end
end
