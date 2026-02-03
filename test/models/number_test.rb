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
end
