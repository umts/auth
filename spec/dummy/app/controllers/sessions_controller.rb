# frozen_string_literal: true

class SessionsController < UMTS::Auth::SessionsController
  after_authenticated { session[:after_authenticated] = true }

  def show; end
end
