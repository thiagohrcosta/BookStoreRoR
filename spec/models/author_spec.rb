require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:about) }
    it { should validate_presence_of(:photo) }
  end

  describe 'associations' do
    it { should have_many(:books) }
  end
end
