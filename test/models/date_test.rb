require 'test_helper'

class DateTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equal to date' do
    value = Date.today

    question = build_question(questionable, 'Date', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', date: value)

    response = responsable.response(question: question)
    response.assign_attributes(date: value)
    assert response.correct?

    response.assign_attributes(date: value + 1.day)
    refute response.correct?
  end

  test 'Within range date' do
    value = Date.today

    question = build_question(questionable, 'Date', scored: true)
    answer = question.question_answers.build(operation: 'Within range', date_begin: value - 1.day, date_end: value + 1.day)

    response = responsable.response(question: question)
    response.assign_attributes(date: value)
    assert response.correct?

    response.assign_attributes(date: value + 5.days)
    refute response.correct?
  end

  test 'Less than date' do
    value = Date.today

    question = build_question(questionable, 'Date', scored: true)
    answer = question.question_answers.build(operation: 'Less than', date: value + 1.day)

    response = responsable.response(question: question)
    response.assign_attributes(date: value)
    assert response.correct?

    response.assign_attributes(date: value + 1.day)
    refute response.correct?
  end

  test 'Less than or equal to date' do
    value = Date.today

    question = build_question(questionable, 'Date', scored: true)
    answer = question.question_answers.build(operation: 'Less than or equal to', date: value)

    response = responsable.response(question: question)
    response.assign_attributes(date: value)
    assert response.correct?

    response.assign_attributes(date: value + 1.day)
    refute response.correct?
  end

  test 'Greater than date' do
    value = Date.today

    question = build_question(questionable, 'Date', scored: true)
    answer = question.question_answers.build(operation: 'Greater than', date: value - 1.day)

    response = responsable.response(question: question)
    response.assign_attributes(date: value)
    assert response.correct?

    response.assign_attributes(date: value - 1.day)
    refute response.correct?
  end

  test 'Greater than or equal to date' do
    value = Date.today

    question = build_question(questionable, 'Date', scored: true)
    answer = question.question_answers.build(operation: 'Greater than or equal to', date: value)

    response = responsable.response(question: question)
    response.assign_attributes(date: value)
    assert response.correct?

    response.assign_attributes(date: value - 1.day)
    refute response.correct?
  end

  test 'question_answer to_s for date' do
    value = Date.new(2025, 6, 15)

    question = build_question(questionable, 'Date', scored: true)

    answer = question.question_answers.build(operation: 'Equal to', date: value)
    assert_equal 'Equal to 2025-06-15', answer.to_s

    answer.assign_attributes(operation: 'Less than', date: value)
    assert_equal 'Less than 2025-06-15', answer.to_s

    answer.assign_attributes(operation: 'Less than or equal to', date: value)
    assert_equal 'Less than or equal to 2025-06-15', answer.to_s

    answer.assign_attributes(operation: 'Greater than', date: value)
    assert_equal 'Greater than 2025-06-15', answer.to_s

    answer.assign_attributes(operation: 'Greater than or equal to', date: value)
    assert_equal 'Greater than or equal to 2025-06-15', answer.to_s

    answer.assign_attributes(operation: 'Within range', date: nil, date_begin: value, date_end: value + 10.days)
    assert_equal 'Between 2025-06-15 and 2025-06-25', answer.to_s
  end
end
