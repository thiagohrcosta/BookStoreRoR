require 'rails_helper'

RSpec.describe AuthorGenre, type: :model do
  describe 'associations' do
    it { should belong_to(:author) }
    it { should belong_to(:genre) }
  end
end
