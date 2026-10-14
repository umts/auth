# frozen_string_literal: true

class User < ApplicationRecord
  validates :entra_uid, presence: true, uniqueness: true
  validates :entra_upn, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
end
