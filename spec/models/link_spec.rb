require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should  validate_presence_of :name }
  it { should  validate_presence_of :url }

  context 'validate url' do
    it 'when url is correct' do
      expect { create(:link, url: 'https://google.com/search?query=anyquery').to_not raise_error(URI::InvalidURIError) }
    end

    it 'when url is incorrect' do
      expect { create(:link, url: 'wrongURL').to raise_error(URI::InvalidURIError) }
    end
  end

  context 'gist' do
    subject(:question) { create(:question) }

    it 'returns true when link is gist' do
      expect( create(:link, url: 'https://gist.github.com/someuser/someid', 
        linkable: question).gist? ).to be_truthy
    end

    it 'returns false when link is not gist' do
      expect( create(:link, url: 'https://google.com/someuser/someid', 
        linkable: question).gist? ).to be_falsy
    end
  end
end
