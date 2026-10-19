# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include UMTS::Auth::Controller

  layout 'umts/brand/private'
end
