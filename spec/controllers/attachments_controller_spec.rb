require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:user) { create(:user) }

  describe 'DELET #destroy' do
    before { login(user) }

    let(:question) { create(:question, :with_file, user: user) }
    let(:other_question) { create(:question, :with_file) }

    it 'deletes file' do
      delete :destroy, params: { id: question.files.first, format: :js }
      question.reload

      expect(question.files).to_not be_attached
    end

    it "does not delete file attached to other user's question" do
      delete :destroy, params: { id: other_question.files.first, format: :js }
      question.reload

      expect(other_question.files).to be_attached
    end
  end

end
