# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user, optional: true
  validates :title, presence: true
end
