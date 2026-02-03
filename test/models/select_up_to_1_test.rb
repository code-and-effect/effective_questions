require 'test_helper'

class SelectUpTo1Test < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Select up to 1 correct option' do
    question = build_question(questionable, 'Select up to 1', scored: true)

    # Mark the first option as a correct answer
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
