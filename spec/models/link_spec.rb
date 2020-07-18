# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('http://localhost').for(:url) }
  it { should_not allow_value('http:##localhost').for(:url) }

  let(:gist_link) { create(:link, url: 'http://gist.github.com/') }
  let(:non_gist_link) { create(:link) }

  describe '#gist?' do
    it 'returns true' do
      expect(gist_link.gist?).to be_truthy
    end

    it 'returns false' do
      expect(non_gist_link.gist?).to be_falsey
    end
  end
end
