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
end
