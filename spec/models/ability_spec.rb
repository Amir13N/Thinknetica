# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }
    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other) }

    it { should be_able_to :delete, create(:question, user: user) }
    it { should_not be_able_to :delete, create(:question, user: other) }
    it { should be_able_to :delete, create(:answer, user: user) }
    it { should_not be_able_to :delete, create(:answer, user: other) }

    it { should be_able_to :vote, create(:question, user: other) }
    it { should_not be_able_to :vote, create(:question, user: user) }
    it { should be_able_to :vote, create(:answer, user: other) }
    it { should_not be_able_to :vote, create(:answer, user: user) }

    it { should_not be_able_to :make_the_best, create(:question, user: other) }
    it { should be_able_to :make_the_best, create(:question, user: user) }

    it { should be_able_to :add_comment, create(:answer) }

    it { should be_able_to :delete_attachment, create(:question, user: user) }
    it { should be_able_to :delete_attachment, create(:answer, user: user) }

    it { should be_able_to :delete_link, create(:question, user: user) }
    it { should be_able_to :delete_link, create(:answer, user: user) }
  end
end
