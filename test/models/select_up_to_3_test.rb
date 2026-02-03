require 'test_helper'

class SelectUpTo3Test < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Select up to 3 correct options' do
    question = build_question(questionable, 'Select up to 3', scored: true)

    # Add a 4th option for testing incorrect selection
    question.question_options.build(title: 'Option D')

    # Mark the first three options as correct answers before saving
    correct_option_a = question.question_options.first
    correct_option_a.answer = true

    correct_option_b = question.question_options.second
    correct_option_b.answer = true

    correct_option_c = question.question_options.third
    correct_option_c.answer = true

    incorrect_option = question.question_options.fourth

    question.save!

    response = responsable.response(question: question)

    # Selecting all 3 correct options
    response.response_options.build(question_option: correct_option_a)
    response.response_options.build(question_option: correct_option_b)
    response.response_options.build(question_option: correct_option_c)
    assert response.correct?

    # Selecting only 2 correct options is still correct
    response.response_options.clear
    response.response_options.build(question_option: correct_option_a)
    response.response_options.build(question_option: correct_option_b)
    assert response.correct?

    # Selecting 1 correct option is still correct
    response.response_options.clear
    response.response_options.build(question_option: correct_option_a)
    assert response.correct?

    # Selecting an incorrect option
    response.response_options.clear
    response.response_options.build(question_option: incorrect_option)
    refute response.correct?

    # Mixing correct and incorrect options
    response.response_options.clear
    response.response_options.build(question_option: correct_option_a)
    response.response_options.build(question_option: incorrect_option)
    refute response.correct?
  end
end
