class PasswordsController < ActionController::Base

  def new
  	@user = User.new
  end 

  def forgot
    params = pass_params
	  if params[:email].blank?
      return render json: {error: 'Email not present'}
    end

    user = User.where(email: params[:email].downcase).take

    if user.present? #&& user.confirmed_at?
      user.generate_password_token!
      # SEND EMAIL HERE
      UserMailer.welcome(user).deliver_now
      render json: {status: 'ok'}, status: :ok
    else
      render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s

    if params[:email].blank?
      return render json: {error: 'Token not present'}
    end

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: {status: 'ok'}, status: :ok
      else
        render json: {error: user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def pass_params
      params.require(:user).permit(:email)
    end
end
