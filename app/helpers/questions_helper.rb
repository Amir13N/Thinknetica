module QuestionsHelper

  def new_answer(params)
    answer = Answer.new(params)
    answer.save
    answer
  end

end
