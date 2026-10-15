# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    authorize!
    @users = User.order(first_name: :asc, last_name: :asc)
  end

  def show
    @user = User.find(params.expect(:id))
    authorize! @user
  end
end
