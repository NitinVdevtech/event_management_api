require 'rails_helper'

RSpec.describe User, type: :model do
  # Associations
  it { should have_many(:events).dependent(:destroy) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  # Password handling
  it { should have_secure_password }
end
