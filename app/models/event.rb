class Event < ApplicationRecord
  belongs_to :user

  validates :name, :location, :description, :start_time, :end_time, presence: true
end
