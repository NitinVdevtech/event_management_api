class Api::V1::AuthenticationsController < ApplicationController

  before_action :authorize_request, only: [:login]

  # POST /signup
  def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken::JwtTokenGenerator.encode(user_id: user.id)
      render json: { user: user, token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    return render_unauthorized('Invalid or missing Authorization token') unless @current_user

    if @current_user.valid? && @current_user.authenticate(params[:user][:password])
      token = JsonWebToken::JwtTokenGenerator.encode(user_id: @current_user.id)
      render_success(@current_user, 'Login successful', token)
    else
      render_unauthorized('Invalid email or password')
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :admin)
  end

  def render_unauthorized(message)
    render json: { errors: message }, status: :unauthorized
  end
  
  def render_success(user, message, token)
    render json: { user: user, token: token, message: message }, status: :ok
  end
end
