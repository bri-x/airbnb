class PasswordsController < Clearance::PasswordsController
  def create
    if user = find_user_for_create
      user.forgot_password!
      deliver_email(user)
    end
    render template: 'passwords/create'
	end

  private

  def deliver_email(user)
    ClearanceMailer::change_password(user).deliver_later
	end
end