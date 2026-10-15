# frozen_string_literal: true

class ApplicationPolicy < ActionPolicy::Base
  include UMTS::Auth::Policy
end
