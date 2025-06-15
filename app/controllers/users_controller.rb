class UsersController < ApplicationController
  before_action :set_devise_vars

  def auth_cards
  end

  private

  def set_devise_vars
    # Sign in 用
    @login_resource = User.new
    @login_resource_name = :user

    # Sign up 用
    @signup_resource = User.new
    @signup_resource_name = :user
  end
end
