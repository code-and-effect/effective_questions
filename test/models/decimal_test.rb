require 'test_helper'

class DecimalTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equal to decimal' do
    value = 10.5

    question = build_question(questionable, 'Decimal', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', decimal: value)

    response = responsable.response(question: question)
    response.assign_attributes(decimal: value)
    assert response.correct?

    response.assign_attributes(decimal: value + 1)
    refute response.correct?
  end

  test 'Within range decimal' do
    value = 10.5

    question = build_question(questionable, 'Decimal', scored: true)
    answer = question.question_answers.build(operation: 'Within range', decimal_begin: value - 1, decimal_end: value + 1)

    response = responsable.response(question: question)
    response.assign_attributes(decimal: value)
    assert response.correct?

    response.assign_attributes(decimal: value + 5)
    refute response.correct?
  end

  test 'Less than decimal' do
    value = 10.5

    question = build_question(questionable, 'Decimal', scored: true)
    answer = question.question_answers.build(operation: 'Less than', decimal: value + 1)

    response = responsable.response(question: question)
    response.assign_attributes(decimal: value)
    assert response.correct?

    response.assign_attributes(decimal: value + 1)
    refute response.correct?
  end

  test 'Less than or equal to decimal' do
    value = 10.5

    question = build_question(questionable, 'Decimal', scored: true)
    answer = question.question_answers.build(operation: 'Less than or equal to', decimal: value)

    response = responsable.response(question: question)
    response.assign_attributes(decimal: value)
    assert response.correct?

    response.assign_attributes(decimal: value + 1)
    refute response.correct?
  end

  test 'Greater than decimal' do
    value = 10.5

    question = build_question(questionable, 'Decimal', scored: true)
    answer = question.question_answers.build(operation: 'Greater than', decimal: value - 1)

    response = responsable.response(question: question)
    response.assign_attributes(decimal: value)
    assert response.correct?

    response.assign_attributes(decimal: value - 1)
    refute response.correct?
  end

  test 'Greater than or equal to decimal' do
    value = 10.5

    question = build_question(questionable, 'Decimal', scored: true)
    answer = question.question_answers.build(operation: 'Greater than or equal to', decimal: value)

    response = responsable.response(question: question)
    response.assign_attributes(decimal: value)
    assert response.correct?

    response.assign_attributes(decimal: value - 1)
    refute response.correct?
  end

  test 'question_answer to_s for decimal' do
    value = 10.5

    question = build_question(questionable, 'Decimal', scored: true)

    answer = question.question_answers.build(operation: 'Equal to', decimal: value)
    assert_equal 'Equal to 10.5', answer.to_s

    answer.assign_attributes(operation: 'Less than', decimal: value)
    assert_equal 'Less than 10.5', answer.to_s

    answer.assign_attributes(operation: 'Less than or equal to', decimal: value)
    assert_equal 'Less than or equal to 10.5', answer.to_s

    answer.assign_attributes(operation: 'Greater than', decimal: value)
    assert_equal 'Greater than 10.5', answer.to_s

    answer.assign_attributes(operation: 'Greater than or equal to', decimal: value)
    assert_equal 'Greater than or equal to 10.5', answer.to_s

    answer.assign_attributes(operation: 'Within range', decimal: nil, decimal_begin: 5.0, decimal_end: 15.0)
    assert_equal 'Between 5.0 and 15.0', answer.to_s
  end
end
