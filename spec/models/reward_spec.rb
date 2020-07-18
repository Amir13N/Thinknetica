# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional(true) }
end
