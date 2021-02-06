# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { have_many_and_belong_to :subscribes }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
end
