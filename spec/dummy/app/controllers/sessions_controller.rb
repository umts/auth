# frozen_string_literal: true

class SessionsController < ApplicationController
  include UMTS::Authentication

  after_authenticated { session[:after_authenticated] = true }

  def show; end
end
