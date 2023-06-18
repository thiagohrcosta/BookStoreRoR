require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:cover_image) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:price) }
  end

  describe 'associations' do
    it { should belong_to(:author) }
  end
end
