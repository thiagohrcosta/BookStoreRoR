require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'associations' do
    it { should have_many(:authors) }
    it { should have_many(:books).through(:authors) }
  end
end
