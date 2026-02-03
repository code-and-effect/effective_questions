require 'test_helper'

class NumberTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equal to number' do
    value = 10

    question = build_question(questionable, 'Number', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', number: value)

    response = responsable.response(question: question)
    response.assign_attributes(number: value)
    assert response.correct?

    response.assign_attributes(number: value + 1)
    refute response.correct?
  end

  test 'Within range number' do
    value = 10

    question = build_question(questionable, 'Number', scored: true)
    answer = question.question_answers.build(operation: 'Within range', number_begin: value - 1, number_end: value + 1)

    response = responsable.response(question: question)
    response.assign_attributes(number: value)
    assert response.correct?

    response.assign_attributes(number: value + 5)
    refute response.correct?
  end

  test 'Less than number' do
    value = 10

    question = build_question(questionable, 'Number', scored: true)
    answer = question.question_answers.build(operation: 'Less than', number: value + 1)

    response = responsable.response(question: question)
    response.assign_attributes(number: value)
    assert response.correct?

    response.assign_attributes(number: value + 1)
    refute response.correct?
  end

  test 'Less than or equal to number' do
    value = 10

    question = build_question(questionable, 'Number', scored: true)
    answer = question.question_answers.build(operation: 'Less than or equal to', number: value)

    response = responsable.response(question: question)
    response.assign_attributes(number: value)
    assert response.correct?

    response.assign_attributes(number: value + 1)
    refute response.correct?
  end

  test 'Greater than number' do
    value = 10

    question = build_question(questionable, 'Number', scored: true)
    answer = question.question_answers.build(operation: 'Greater than', number: value - 1)

    response = responsable.response(question: question)
    response.assign_attributes(number: value)
    assert response.correct?

    response.assign_attributes(number: value - 1)
    refute response.correct?
  end

  test 'Greater than or equal to number' do
    value = 10

    question = build_question(questionable, 'Number', scored: true)
    answer = question.question_answers.build(operation: 'Greater than or equal to', number: value)

    response = responsable.response(question: question)
    response.assign_attributes(number: value)
    assert response.correct?

    response.assign_attributes(number: value - 1)
    refute response.correct?
  end

  test 'question_answer to_s for number' do
    value = 42

    question = build_question(questionable, 'Number', scored: true)

    answer = question.question_answers.build(operation: 'Equal to', number: value)
    assert_equal 'Equal to 42', answer.to_s

    answer.assign_attributes(operation: 'Less than', number: value)
    assert_equal 'Less than 42', answer.to_s

    answer.assign_attributes(operation: 'Less than or equal to', number: value)
    assert_equal 'Less than or equal to 42', answer.to_s

    answer.assign_attributes(operation: 'Greater than', number: value)
    assert_equal 'Greater than 42', answer.to_s

    answer.assign_attributes(operation: 'Greater than or equal to', number: value)
    assert_equal 'Greater than or equal to 42', answer.to_s

    answer.assign_attributes(operation: 'Within range', number: nil, number_begin: 10, number_end: 50)
    assert_equal 'Between 10 and 50', answer.to_s
  end
end
