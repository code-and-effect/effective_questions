require 'test_helper'

class ChooseOneTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Choose one correct option' do
    question = build_question(questionable, 'Choose one', scored: true)

    # Mark the first option as the correct answer
    correct_option = question.question_options.first
    correct_option.update!(answer: true)

    incorrect_option = question.question_options.second

    response = responsable.response(question: question)
    response.response_options.build(question_option: correct_option)
    assert response.correct?

    response.response_options.clear
    response.response_options.build(question_option: incorrect_option)
    refute response.correct?
  end
end
