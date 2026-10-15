# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index? = Current.user.present?

  def show? = record == Current.user
end
