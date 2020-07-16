# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_file, user: user) }
  let(:other_question) { create(:question, :with_file) }

  describe 'DELETE #destroy' do
    before { login(user) }

    it 'deletes file' do
      expect { delete :destroy, params: { id: question.files.first, format: :js } }.to change(question.files, :count).by(-1)
    end

    it "does not delete file attached to other user's question" do
      expect { delete :destroy, params: { id: other_question.files.first, format: :js } }.to_not change(other_question.files, :count)
    end

    it 'renders destroy view' do
      delete :destroy, params: { id: other_question.files.first, format: :js }

      expect(response).to render_template :destroy
    end
  end

  it 'Unauthenticated user can not delete files' do
    expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
  end
end
