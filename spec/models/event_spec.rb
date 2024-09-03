require 'rails_helper'

RSpec.describe Event, type: :model do
  # Associations
  it { should belong_to(:user) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }

end
