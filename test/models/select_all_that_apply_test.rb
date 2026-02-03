require 'test_helper'

class SelectAllThatApplyTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Select all that apply correct options' do
    question = build_question(questionable, 'Select all that apply', scored: true)

    # Mark the first two options as correct answers
    correct_option_a = question.question_options.first
    correct_option_a.update!(answer: true)

    correct_option_b = question.question_options.second
    correct_option_b.update!(answer: true)

    incorrect_option = question.question_options.third

    response = responsable.response(question: question)
    response.response_options.build(question_option: correct_option_a)
    response.response_options.build(question_option: correct_option_b)
    assert response.correct?

    # Missing one correct option
    response.response_options.clear
    response.response_options.build(question_option: correct_option_a)
    refute response.correct?

    # Including an incorrect option
    response.response_options.clear
    response.response_options.build(question_option: correct_option_a)
    response.response_options.build(question_option: correct_option_b)
    response.response_options.build(question_option: incorrect_option)
    refute response.correct?
  end
end
